
"use client";

import { useAppKit, useAppKitAccount } from "@reown/appkit/react";
import { FaRocket } from "react-icons/fa";

export default function ConnectWalletBtn() {
  const { open } = useAppKit();
  const { address, isConnected } = useAppKitAccount();

  const formatAddress = (addr) => {
    if (!addr) return "";
    return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
  };

  if (isConnected && address) {
    return (
      <button
        onClick={() => open({ view: "Account" })}
        className="bg-ftty-orange hover:bg-ftty-orange-light text-white px-8 py-4 rounded-full text-lg font-medium flex items-center justify-center gap-2 transform transition-all hover:scale-105 shadow-lg hover:shadow-xl hover:shadow-ftty-orange/20"
      >
        <FaRocket />
        {formatAddress(address)}
      </button>
    );
  }

  return (
