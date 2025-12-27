import { WagmiAdapter } from "@reown/appkit-adapter-wagmi";
import { createAppKit } from "@reown/appkit/react";
import { mainnet } from "@reown/appkit/networks";
import { createStorage, cookieStorage } from "@wagmi/core";

const projectId = process.env.NEXT_PUBLIC_REOWN_PROJECT_ID;