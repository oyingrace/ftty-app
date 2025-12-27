// components/Hero.jsx
'use client';
import { useEffect, useRef } from 'react';
import { FaRocket, FaGamepad, FaCoins } from 'react-icons/fa';
import {  
  AppKitConnectButton, 
} from "@reown/appkit/react";
import "@reown/appkit-wallet-button/react";

const Hero = () => {
  const heroRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('opacity-100');
          entry.target.classList.remove('opacity-0', 'translate-y-10');
        }
      },
      { threshold: 0.1 }
    );

    if (heroRef.current) {
      observer.observe(heroRef.current);
    }

    return () => {
      if (heroRef.current) {
        observer.unobserve(heroRef.current);
      }
    };
  }, []);

  return (
    <section className="pt-32 pb-20 md:pt-40 md:pb-32 relative overflow-hidden">
      {/* Background Elements */}
      <img 
        src="/pirate.png" 
        alt="Pirate decoration" 
        className="absolute top-20 left-10 w-20 h-20 object-contain -z-10"
      />
      <div className="absolute bottom-20 right-10 w-32 h-32 rounded-full bg-ftty-orange opacity-10 animate-pulse-slow -z-10" style={{ animationDelay: '1s' }}></div>
      <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 rounded-full bg-ftty-orange opacity-5 blur-3xl -z-10"></div>

      <div
        ref={heroRef}
        className="container mx-auto px-4 flex flex-col items-center text-center transition duration-1000 opacity-0 translate-y-10"
      >
        <div className="relative mb-6 inline-block">
          <span className="text-2xl md:text-3xl font-medium text-ftty-orange flex items-center justify-center gap-2">
            <FaGamepad className="animate-float" style={{ animationDelay: '0.5s' }} />
            Gaming Assets Marketplace
            <FaCoins className="animate-float" />
          </span>
        </div>

        <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold mb-6 leading-tight">
          <span className="text-white">Trade Gaming Assets with </span>
          <span className="text-ftty-orange glow">FTTY Token</span>
        </h1>

        <p className="text-lg md:text-xl text-gray-300 max-w-3xl mb-12">
          The next-generation platform for buying, selling, and trading in-game assets
          using cryptocurrency. Secure, fast, and commission-free.
        </p>

        <div className="flex flex-col sm:flex-row gap-6 justify-center">
         
        <appkit-wallet-button wallet="metamask" namespace='eip155' />
          
          <button
            onClick={() => window.open('/whitepaper.pdf', '_blank')}
            className="bg-transparent hover:bg-ftty-purple-light text-white border border-ftty-orange px-8 py-4 rounded-full text-lg font-medium transition-all hover:border-ftty-orange-light"
          >
            Whitepaper
          </button>
        </div>

        <div className="mt-16 grid grid-cols-3 gap-6 max-w-3xl w-full">
          <div className="card-gradient rounded-xl p-4 transform transition-all hover:scale-105 hover:shadow-lg">
            <p className="text-ftty-orange font-bold text-3xl md:text-4xl mb-1">20+</p>
            <p className="text-gray-300 text-sm md:text-base">Games Supported</p>
          </div>
          <div className="card-gradient rounded-xl p-4 transform transition-all hover:scale-105 hover:shadow-lg">
            <p className="text-ftty-orange font-bold text-3xl md:text-4xl mb-1">0%</p>
            <p className="text-gray-300 text-sm md:text-base">Commission Fee</p>
          </div>
          <div className="card-gradient rounded-xl p-4 transform transition-all hover:scale-105 hover:shadow-lg">
            <p className="text-ftty-orange font-bold text-3xl md:text-4xl mb-1">50+</p>
            <p className="text-gray-300 text-sm md:text-base">Beta Users</p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;