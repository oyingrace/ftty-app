"use client";

import { createAppKit } from "@reown/appkit/react";
import { WagmiAdapter } from "@reown/appkit-adapter-wagmi";
import { mainnet } from "@reown/appkit/networks"; // or other networks

// Create adapter
const wagmiAdapter = new WagmiAdapter({
  networks: [mainnet],
  projectId: process.env.NEXT_PUBLIC_REOWN_PROJECT_ID,
});

// Create appkit instance
const appKit = createAppKit({
  adapters: [wagmiAdapter],
  networks: [mainnet],
  projectId: process.env.NEXT_PUBLIC_REOWN_PROJECT_ID,
});

export default function AppKitProvider({ children }) {
  return <>{children}</>;
}