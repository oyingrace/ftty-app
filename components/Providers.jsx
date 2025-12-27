"use client";

import { createAppKit } from "@reown/appkit/react";
import { mainnet } from "@reown/appkit/networks";

// Initialize AppKit outside component (as per docs recommendation)
const projectId = process.env.NEXT_PUBLIC_REOWN_PROJECT_ID;

if (!projectId || projectId === "YOUR_PROJECT_ID") {
  console.warn(
    "⚠️ Reown Project ID not configured. Please set NEXT_PUBLIC_REOWN_PROJECT_ID in your .env.local file.\n" +
    "Get your Project ID from: https://cloud.reown.com"
  );
}

// Create appkit instance
createAppKit({
  networks: [mainnet],
  projectId: projectId || "5acef91d7967e48a748a4a68f1cb790c",
  enableWallets: true, // Keep wallet buttons enabled
  features: {
    connectMethodsOrder: ["wallet"], // Only show wallet buttons, no QR/social/email
  },
});

export default function Providers({ children }) {
  return <>{children}</>;
}