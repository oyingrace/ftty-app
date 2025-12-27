import { WagmiAdapter } from "@reown/appkit-adapter-wagmi";
import { createAppKit } from "@reown/appkit/react";
import { mainnet } from "@reown/appkit/networks";
import { createStorage, cookieStorage } from "@wagmi/core";

const projectId = process.env.NEXT_PUBLIC_REOWN_PROJECT_ID;

if (!projectId) {
    throw new Error("NEXT_PUBLIC_REOWN_PROJECT_ID is not defined");
}  

const wagmiAdapter = new WagmiAdapter({
    projectId,
    storage: createStorage({
      storage: cookieStorage,
    }),
    ssr: true,
    networks: [mainnet],
});

createAppKit({
    projectId,
    adapters: [wagmiAdapter],
    networks: [mainnet],
    metadata: {
      name: "FTTY",
      description: "FTTY - Gaming Assets Crypto Marketplace",
      url: "https://ftty.xyz",
      icons: [],
    },
  });