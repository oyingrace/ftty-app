"use client";

import { useEffect, useState } from "react";
import { useAppKitWallet } from "@reown/appkit-wallet-button/react";
import { FaRocket } from "react-icons/fa";

export default function ConnectWalletBtn() {
  const [connectionError, setConnectionError] = useState(null);
  
  const { isReady, isPending, connect, isSuccess, data, disconnect: disconnectWallet, error } = useAppKitWallet({
    namespace: "eip155", // For EVM wallets
    onSuccess(parsedCaipAddress) {
      console.log("Connected:", parsedCaipAddress);
      setConnectionError(null);
    },
    onError(error) {
      console.error("Connection error:", error);
      setConnectionError(error?.message || "Connection failed");
    },
  });

  useEffect(() => {
    console.log("AppKit Wallet State:", { isReady, isPending, isSuccess, data, error });
  }, [isReady, isPending, isSuccess, data, error]);

  // Reset stuck state after timeout
  useEffect(() => {
    if (isPending && !isReady) {
      const timeout = setTimeout(() => {
        console.warn("Connection timeout - AppKit may not be properly initialized");
        setConnectionError("Connection timeout. Please check your Reown Project ID configuration.");
      }, 10000); // 10 second timeout
      
      return () => clearTimeout(timeout);
    }
  }, [isPending, isReady]);

  const formatAddress = (address) => {
    if (!address) return "";
    // Handle CAIP address format (eip155:1:0x...)
    const parts = address.split(":");
    const addr = parts.length > 2 ? parts[2] : address;
    return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
  };

  const handleConnect = () => {
    if (!isReady) {
      console.error("AppKit is not ready. Please check your Reown Project ID configuration.");
      setConnectionError("AppKit not initialized. Please check console for details.");
      return;
    }
    
    setConnectionError(null);
    // Use "walletConnect" to open the modal with all available wallets
    try {
      connect("walletConnect");
    } catch (err) {
      console.error("Failed to open wallet modal:", err);
      setConnectionError(err?.message || "Failed to open wallet selection");
    }
  };

  if (isSuccess && data) {
    return (
      <button
        onClick={() => disconnectWallet()}
        className="bg-ftty-orange hover:bg-ftty-orange-light text-white px-8 py-4 rounded-full text-lg font-medium flex items-center justify-center gap-2 transform transition-all hover:scale-105 shadow-lg hover:shadow-xl hover:shadow-ftty-orange/20"
      >
        <span>{formatAddress(data)}</span>
        <span className="text-sm">(Disconnect)</span>
      </button>
    );
  }

  return (
    <div className="flex flex-col items-center gap-2">
      <button
        onClick={handleConnect}
        disabled={isPending || !isReady}
        className="bg-ftty-orange hover:bg-ftty-orange-light text-white px-8 py-4 rounded-full text-lg font-medium flex items-center justify-center gap-2 transform transition-all hover:scale-105 shadow-lg hover:shadow-xl hover:shadow-ftty-orange/20 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <FaRocket />
        {isPending ? "Connecting..." : !isReady ? "Initializing..." : "Connect Wallet"}
      </button>
      {connectionError && (
        <p className="text-red-400 text-sm text-center max-w-md">
          {connectionError}
        </p>
      )}
      {!isReady && !connectionError && (
        <p className="text-yellow-400 text-sm text-center max-w-md">
          ⚠️ AppKit not ready. Check console for initialization issues.
        </p>
      )}
    </div>
  );
}