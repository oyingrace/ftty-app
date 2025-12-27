// components/Navbar.jsx
'use client';
import { useState, useEffect } from 'react';
import { FaWallet, FaBars, FaTimes } from 'react-icons/fa';
import {  
  AppKitConnectButton, 
} from "@reown/appkit/react";

const Navbar = () => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 20) {
        setIsScrolled(true);
      } else {
        setIsScrolled(false);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <header className={`fixed w-full z-50 transition-all duration-300 ${isScrolled ? 'bg-ftty-purple-darker py-2 shadow-lg' : 'bg-transparent py-4'}`}>
      <div className="container mx-auto px-4 flex justify-between items-center">
        <a href="#" className="text-ftty-orange text-2xl md:text-3xl font-bold glow">
          FTTY
        </a>

        {/* Desktop Navigation */}
        <nav className="hidden md:flex items-center space-x-8">
          <a href="#" className="text-white hover:text-ftty-orange transition-colors">Home</a>
          <a href="#features" className="text-white hover:text-ftty-orange transition-colors">Features</a>
          <a href="#community" className="text-white hover:text-ftty-orange transition-colors">Community</a>
          <a href="#roadmap" className="text-white hover:text-ftty-orange transition-colors">Roadmap</a>
        
        </nav>

        {/* Mobile Menu Button */}
        <button 
          className="md:hidden text-white text-xl"
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
        >
          {mobileMenuOpen ? <FaTimes /> : <FaBars />}
        </button>
      </div>

      {/* Mobile Navigation */}
      {mobileMenuOpen && (
        <div className="md:hidden bg-ftty-purple-dark absolute top-full left-0 w-full py-4 shadow-lg animate-fade-in">
          <div className="container mx-auto px-4 flex flex-col space-y-4">
            <a 
              href="#" 
              className="text-white hover:text-ftty-orange transition-colors py-2"
              onClick={() => setMobileMenuOpen(false)}
            >
              Home
            </a>
            <a 
              href="#features" 
              className="text-white hover:text-ftty-orange transition-colors py-2"
              onClick={() => setMobileMenuOpen(false)}
            >
              Features
            </a>
            <a 
              href="#community" 
              className="text-white hover:text-ftty-orange transition-colors py-2"
              onClick={() => setMobileMenuOpen(false)}
            >
              Community
            </a>
            <a 
              href="#roadmap" 
              className="text-white hover:text-ftty-orange transition-colors py-2"
              onClick={() => setMobileMenuOpen(false)}
            >
              Roadmap
            </a>
           
          </div>
        </div>
      )}
    </header>
  );
};

export default Navbar;