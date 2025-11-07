// dpp
import { Plugin } from "jsr:@shougo/dpp-vim@5.0.0/types";
import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  MultipleHook,
} from "jsr:@shougo/dpp-vim@5.0.0/config";

// denops
import * as fn from "jsr:@denops/std@8.1.1/function";

// std
import { expandGlob } from "jsr:@std/fs";

type Toml = {
  ftplugins?: Record<string, string>;
  hooks_file?: string;
  multiple_plugins?: Plugin[] & {
    plugins: string[];
  };
  plugins?: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

async function getToml(args: ConfigArguments, lazy: boolean, path: string) {
  const [context, options] = await args.contextBuilder.get(args.denops);

  return args.dpp.extAction(args.denops, context, options, "toml", "load", {
    path: path,
    options: {
      lazy: lazy,
    },
  }) as Toml | undefined;
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { contextBuilder, denops, dpp } = args;
    const [context, options] = await contextBuilder.get(denops);

    contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    const _multipleHooks: MultipleHook[] = [];
    const tomls: Toml[] = [];

    // Search for toml files
    const normalTomlDir = await fn.expand(denops, "$NORMAL_TOML_DIR");
    const lazyTomlDir = await fn.expand(denops, "$LAZY_TOML_DIR");
    const BASE_DIR = await fn.expand(denops, "$BASE_DIR");

    const normalTomlFiles = expandGlob(`${normalTomlDir}/*.toml`, {
      globstar: true,
    });
    const lazyTomlFiles = expandGlob(`${lazyTomlDir}/*.toml`, {
      globstar: true,
    });

    for await (const file of normalTomlFiles) {
      const toml = await getToml(args, false, file.path);
      toml && tomls.push(toml);
    }

    for await (const file of lazyTomlFiles) {
      const toml = await getToml(args, true, file.path);
      toml && tomls.push(toml);
    }

    tomls.forEach((toml) => {
      for (const plugin of toml.plugins || []) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    });

    const lazyResult = (await dpp.extAction(
      denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    )) as LazyMakeStateResult | undefined;

    const checkFiles: string[] = [];
    for await (const file of expandGlob(`${BASE_DIR}/**/*`)) {
      checkFiles.push(file.path);
    }

    return {
      checkFiles: checkFiles,
      ftplugins: ftplugins,
      hooksFiles: hooksFiles,
      plugins: lazyResult?.plugins || [],
      stateLines: lazyResult?.stateLines || [],
    };
  }
}
