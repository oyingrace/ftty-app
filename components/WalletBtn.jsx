
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
