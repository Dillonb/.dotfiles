# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@mistweaverco/tree-sitter-kulala-1.0.12" = {
      name = "_at_mistweaverco_slash_tree-sitter-kulala";
      packageName = "@mistweaverco/tree-sitter-kulala";
      version = "1.0.12";
      src = fetchurl {
        url = "https://registry.npmjs.org/@mistweaverco/tree-sitter-kulala/-/tree-sitter-kulala-1.0.12.tgz";
        sha512 = "Tip/iIhfTYIrnVgsrw+S9TXeAKQfdr0vJcuShW6Q2E15nb57voR83ZLoLFZTN0nSH8fg325NDZoxY16g408pjg==";
      };
    };
    "agent-base-4.3.0" = {
      name = "agent-base";
      packageName = "agent-base";
      version = "4.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/agent-base/-/agent-base-4.3.0.tgz";
        sha512 = "salcGninV0nPrwpGNn4VTXBb1SOuXQBiqbrNXoeizJsHrsL6ERFM2Ne3JUSBWRE6aeNJI2ROP/WEEIDUiDe3cg==";
      };
    };
    "argparse-1.0.10" = {
      name = "argparse";
      packageName = "argparse";
      version = "1.0.10";
      src = fetchurl {
        url = "https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz";
        sha512 = "o5Roy6tNG4SL/FOkCAN6RzjiakZS25RLYFrcMttJqbdd8BWrnA+fGz57iN5Pb06pvBGvl5gQ0B48dJlslXvoTg==";
      };
    };
    "azure-pipelines-language-service-0.8.0" = {
      name = "azure-pipelines-language-service";
      packageName = "azure-pipelines-language-service";
      version = "0.8.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/azure-pipelines-language-service/-/azure-pipelines-language-service-0.8.0.tgz";
        sha512 = "bL1iqK+mlp19VZ/YVVq+JQKl/Ciqf6GC+bulKkV11MHpXnM0zoySSYFSyYPJSbe9vZHwvMeF6VXxICKjj+IcWg==";
      };
    };
    "debug-3.1.0" = {
      name = "debug";
      packageName = "debug";
      version = "3.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-3.1.0.tgz";
        sha512 = "OX8XqP7/1a9cqkxYw2yXss15f26NKWBpDXQd0/uK/KPqdQhxbPa994hnzjcE2VqQpDslf55723cKPUOGSmMY3g==";
      };
    };
    "es6-promise-4.2.8" = {
      name = "es6-promise";
      packageName = "es6-promise";
      version = "4.2.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-promise/-/es6-promise-4.2.8.tgz";
        sha512 = "HJDGx5daxeIvxdBxvG2cb9g4tEvwIk3i8+nhX0yGrYmZUzbkdg8QbDevheDB8gd0//uPj4c1EQua8Q+MViT0/w==";
      };
    };
    "es6-promisify-5.0.0" = {
      name = "es6-promisify";
      packageName = "es6-promisify";
      version = "5.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-promisify/-/es6-promisify-5.0.0.tgz";
        sha512 = "C+d6UdsYDk0lMebHNR4S2NybQMMngAOnOwYBQjTOiv0MkoJMP0Myw2mgpDLBcpfCmRLxyFqYhS/CfOENq4SJhQ==";
      };
    };
    "esprima-4.0.1" = {
      name = "esprima";
      packageName = "esprima";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz";
        sha512 = "eGuFFw7Upda+g4p+QHvnW0RyTX/SVeJBDM/gCtMARO0cLuT2HcEKnTPvhjV6aGeqrCB/sbNop0Kszm0jsaWU4A==";
      };
    };
    "http-proxy-agent-2.1.0" = {
      name = "http-proxy-agent";
      packageName = "http-proxy-agent";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-2.1.0.tgz";
        sha512 = "qwHbBLV7WviBl0rQsOzH6o5lwyOIvwp/BdFnvVxXORldu5TmjFfjzBcWUWS5kWAZhmv+JtiDhSuQCp4sBfbIgg==";
      };
    };
    "https-proxy-agent-2.2.4" = {
      name = "https-proxy-agent";
      packageName = "https-proxy-agent";
      version = "2.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-2.2.4.tgz";
        sha512 = "OmvfoQ53WLjtA9HeYP9RNrWMJzzAz1JGaSFr1nijg0PVR1JaD/xbJq1mdEIIlxGpXp9eSe/O2LgU9DJmTPd0Eg==";
      };
    };
    "js-yaml-3.13.1" = {
      name = "js-yaml";
      packageName = "js-yaml";
      version = "3.13.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/js-yaml/-/js-yaml-3.13.1.tgz";
        sha512 = "YfbcO7jXDdyj0DGxYVSlSeQNHbD7XPWvrVWeVUujrQEoZzWJIRrCPoyk6kL6IAjAG2IolMK4T0hNUe0HOUs5Jw==";
      };
    };
    "jsonc-parser-2.0.2" = {
      name = "jsonc-parser";
      packageName = "jsonc-parser";
      version = "2.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-2.0.2.tgz";
        sha512 = "TSU435K5tEKh3g7bam1AFf+uZrISheoDsLlpmAo6wWZYqjsnd09lHYK1Qo+moK4Ikifev1Gdpa69g4NELKnCrQ==";
      };
    };
    "jsonc-parser-3.3.1" = {
      name = "jsonc-parser";
      packageName = "jsonc-parser";
      version = "3.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.3.1.tgz";
        sha512 = "HUgH65KyejrUFPvHFPbqOY0rsFip3Bo5wb4ngvdi1EpCYWUQDC5V+Y7mZws+DLkr4M//zQJoanu1SP+87Dv1oQ==";
      };
    };
    "ms-2.0.0" = {
      name = "ms";
      packageName = "ms";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz";
        sha512 = "Tpp60P6IUJDTuOq/5Z8cdskzJujfwqfOTkrwIwj7IRISpnkJnT6SyJ4PCPnGMoFjC9ddhal5KVIYtAt97ix05A==";
      };
    };
    "node-addon-api-8.1.0" = {
      name = "node-addon-api";
      packageName = "node-addon-api";
      version = "8.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.1.0.tgz";
        sha512 = "yBY+qqWSv3dWKGODD6OGE6GnTX7Q2r+4+DfpqxHSHh8x0B4EKP9+wVGLS6U/AM1vxSNNmUEuIV5EGhYwPpfOwQ==";
      };
    };
    "node-gyp-build-4.8.2" = {
      name = "node-gyp-build";
      packageName = "node-gyp-build";
      version = "4.8.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-gyp-build/-/node-gyp-build-4.8.2.tgz";
        sha512 = "IRUxE4BVsHWXkV/SFOut4qTlagw2aM8T5/vnTsmrHJvVoKueJHRc/JaFND7QDDc61kLYUJ6qlZM3sqTSyx2dTw==";
      };
    };
    "request-light-0.4.0" = {
      name = "request-light";
      packageName = "request-light";
      version = "0.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/request-light/-/request-light-0.4.0.tgz";
        sha512 = "fimzjIVw506FBZLspTAXHdpvgvQebyjpNyLRd0e6drPPRq7gcrROeGWRyF81wLqFg5ijPgnOQbmfck5wdTqpSA==";
      };
    };
    "sprintf-js-1.0.3" = {
      name = "sprintf-js";
      packageName = "sprintf-js";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha512 = "D9cPgkvLlV3t3IzL0D0YLvGA9Ahk4PcvVwUbN0dSGr1aP0Nrt4AEnTUbuGvquEC0mA64Gqt1fzirlRs5ibXx8g==";
      };
    };
    "tree-sitter-0.21.1" = {
      name = "tree-sitter";
      packageName = "tree-sitter";
      version = "0.21.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/tree-sitter/-/tree-sitter-0.21.1.tgz";
        sha512 = "7dxoA6kYvtgWw80265MyqJlkRl4yawIjO7S5MigytjELkX43fV2WsAXzsNfO7sBpPPCF5Gp0+XzHk0DwLCq3xQ==";
      };
    };
    "vscode-json-languageservice-4.2.1" = {
      name = "vscode-json-languageservice";
      packageName = "vscode-json-languageservice";
      version = "4.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-json-languageservice/-/vscode-json-languageservice-4.2.1.tgz";
        sha512 = "xGmv9QIWs2H8obGbWg+sIPI/3/pFgj/5OWBhNzs00BkYQ9UaB2F6JJaGB/2/YOZJ3BvLXQTC4Q7muqU25QgAhA==";
      };
    };
    "vscode-jsonrpc-6.0.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0.tgz";
        sha512 = "wnJA4BnEjOSyFMvjZdpiOwhSq9uDoK8e/kpRJDTaMYzwlkrhG1fwDIZI94CLsLzlCK5cIbMMtFlJlfR57Lavmg==";
      };
    };
    "vscode-languageserver-7.0.0" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "7.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-7.0.0.tgz";
        sha512 = "60HTx5ID+fLRcgdHfmz0LDZAXYEV68fzwG0JWwEPBode9NuMYTIxuYXPg4ngO8i8+Ou0lM7y6GzaYWbiDL0drw==";
      };
    };
    "vscode-languageserver-protocol-3.16.0" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0.tgz";
        sha512 = "sdeUoAawceQdgIfTI+sdcwkiK2KU+2cbEYA0agzM2uqaUy2UpnnGHtWTHVEtS0ES4zHU0eMFRGN+oQgDxlD66A==";
      };
    };
    "vscode-languageserver-textdocument-1.0.12" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.12";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.12.tgz";
        sha512 = "cxWNPesCnQCcMPeenjKKsOCKQZ/L6Tv19DTRIGuLWe32lyzWhihGVJ/rcckZXJxfdKCFvRLS3fpBIsV/ZGX4zA==";
      };
    };
    "vscode-languageserver-types-3.16.0" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha512 = "k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==";
      };
    };
    "vscode-languageserver-types-3.17.5" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.5.tgz";
        sha512 = "Ld1VelNuX9pdF39h2Hgaeb5hEZM2Z3jUrrMgWQAu82jMtZp7p3vJT3BzToKtZI7NgQssZje5o0zryOrhQvzQAg==";
      };
    };
    "vscode-nls-4.1.2" = {
      name = "vscode-nls";
      packageName = "vscode-nls";
      version = "4.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-nls/-/vscode-nls-4.1.2.tgz";
        sha512 = "7bOHxPsfyuCqmP+hZXscLhiHwe7CSuFE4hyhbs22xPIhQ4jv99FcR4eBzfYYVLP356HNFpdvz63FFb/xw6T4Iw==";
      };
    };
    "vscode-nls-5.2.0" = {
      name = "vscode-nls";
      packageName = "vscode-nls";
      version = "5.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-nls/-/vscode-nls-5.2.0.tgz";
        sha512 = "RAaHx7B14ZU04EU31pT+rKz2/zSl7xMsfIZuo8pd+KZO6PXtQmpevpq3vxvWNcrGbdmhM/rr5Uw5Mz+NBfhVng==";
      };
    };
    "vscode-uri-3.0.8" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.8.tgz";
        sha512 = "AyFQ0EVmsOZOlAnxoFOGOq1SQDWAB7C6aqMGS23svWAllfOaxbuFvcT8D1i8z3Gyn8fraVeZNNmN6e9bxxXkKw==";
      };
    };
    "yaml-ast-parser-0.0.43" = {
      name = "yaml-ast-parser";
      packageName = "yaml-ast-parser";
      version = "0.0.43";
      src = fetchurl {
        url = "https://registry.npmjs.org/yaml-ast-parser/-/yaml-ast-parser-0.0.43.tgz";
        sha512 = "2PTINUwsRqSd+s8XxKaJWQlUuEMHJQyEuh2edBbW8KNJz0SJPwUSD2zRWqezFEdN7IzAgeuYHFUCF7o8zRdZ0A==";
      };
    };
  };
in
{
  azure-pipelines-language-server = nodeEnv.buildNodePackage {
    name = "azure-pipelines-language-server";
    packageName = "azure-pipelines-language-server";
    version = "0.8.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/azure-pipelines-language-server/-/azure-pipelines-language-server-0.8.0.tgz";
      sha512 = "js2vhhpZCVvZtwKCzkZbY0zU/5tqKNTmR1tmkSulJE/b66JHVDyumDLIwfqypHIE1YNX0fl+GNcCJ/ntqyt/VA==";
    };
    dependencies = [
      sources."agent-base-4.3.0"
      sources."argparse-1.0.10"
      sources."azure-pipelines-language-service-0.8.0"
      sources."debug-3.1.0"
      sources."es6-promise-4.2.8"
      sources."es6-promisify-5.0.0"
      sources."esprima-4.0.1"
      sources."http-proxy-agent-2.1.0"
      sources."https-proxy-agent-2.2.4"
      sources."js-yaml-3.13.1"
      sources."jsonc-parser-2.0.2"
      sources."ms-2.0.0"
      (sources."request-light-0.4.0" // {
        dependencies = [
          sources."vscode-nls-4.1.2"
        ];
      })
      sources."sprintf-js-1.0.3"
      (sources."vscode-json-languageservice-4.2.1" // {
        dependencies = [
          sources."jsonc-parser-3.3.1"
        ];
      })
      sources."vscode-jsonrpc-6.0.0"
      sources."vscode-languageserver-7.0.0"
      (sources."vscode-languageserver-protocol-3.16.0" // {
        dependencies = [
          sources."vscode-languageserver-types-3.16.0"
        ];
      })
      sources."vscode-languageserver-textdocument-1.0.12"
      sources."vscode-languageserver-types-3.17.5"
      sources."vscode-nls-5.2.0"
      sources."vscode-uri-3.0.8"
      sources."yaml-ast-parser-0.0.43"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Azure Pipelines language server";
      homepage = "https://github.com/microsoft/azure-pipelines-language-server#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
  "@mistweaverco/kulala-ls" = nodeEnv.buildNodePackage {
    name = "_at_mistweaverco_slash_kulala-ls";
    packageName = "@mistweaverco/kulala-ls";
    version = "1.0.12";
    src = fetchurl {
      url = "https://registry.npmjs.org/@mistweaverco/kulala-ls/-/kulala-ls-1.0.12.tgz";
      sha512 = "+v17jTfEtg7n4f5uDqAsQfTUpdjFwpB/n8sLCKzzu15BzqCxN1zZokRXRrc+BXKX8KE6pyAgk0y9Cm2H3/Nalg==";
    };
    dependencies = [
      sources."@mistweaverco/tree-sitter-kulala-1.0.12"
      sources."node-addon-api-8.1.0"
      sources."node-gyp-build-4.8.2"
      sources."tree-sitter-0.21.1"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "A minimal language server for HTTP syntax.";
      homepage = "https://github.com/mistweaverco/kulala-ls";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}