"use client";

import { useEffect } from "react";
import { createAppKit } from "@reown/appkit/react";
import { mainnet } from "@reown/appkit/networks";

// Initialize AppKit once
let appKitInitialized = false;

export default function Providers({ children }) {
  useEffect(() => {
    if (!appKitInitialized) {
      const projectId = process.env.NEXT_PUBLIC_REOWN_PROJECT_ID;
      
      if (!projectId || projectId === "YOUR_PROJECT_ID") {
        console.warn(
          "⚠️ Reown Project ID not configured. Please set NEXT_PUBLIC_REOWN_PROJECT_ID in your .env.local file.\n" +
          "Get your Project ID from: https://cloud.reown.com"
        );
      }

      try {
        createAppKit({
          networks: [mainnet],
          projectId: projectId || "YOUR_PROJECT_ID",
        });
        appKitInitialized = true;
        console.log("AppKit initialized");
      } catch (error) {
        console.error("Failed to initialize AppKit:", error);
      }
    }
  }, []);

  return <>{children}</>;
}