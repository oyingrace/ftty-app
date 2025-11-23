// components/Chains.jsx
'use client';
import { useState, useEffect, useRef } from 'react';
import { 
  FaEthereum, 
  FaCheck, 
  FaTimes, 
  FaCopy, 
  FaCheckCircle 
} from 'react-icons/fa';
import { SiPolygon, SiBinance, SiSolana } from 'react-icons/si';

const ChainCard = ({ 
  name, 
  icon, 
  isPaired, 
  contractAddress = null, 
  color, 
  delay 
}) => {
  const [copied, setCopied] = useState(false);
  const cardRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setTimeout(() => {
            entry.target.classList.add('opacity-100');
            entry.target.classList.remove('opacity-0', 'translate-y-10');
          }, delay);
        }
      },
      { threshold: 0.1 }
    );

    if (cardRef.current) {
      observer.observe(cardRef.current);
    }

    return () => {
      if (cardRef.current) {
        observer.unobserve(cardRef.current);
      }
    };
  }, [delay]);

  const copyToClipboard = () => {
    if (!contractAddress) return;
    
    navigator.clipboard.writeText(contractAddress).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  return (
    <div 
      ref={cardRef}
      className="card-gradient rounded-xl p-6 transition duration-700 opacity-0 translate-y-10 border border-ftty-purple-light hover:border-ftty-orange/40"
    >
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className={`text-3xl ${color}`}>
            {icon}
          </div>
          <h3 className="text-xl font-semibold">{name}</h3>
        </div>
        <div className={`${isPaired ? 'text-green-500' : 'text-orange-500'} flex items-center gap-2`}>
          {isPaired ? (
            <>
              <FaCheck />
              <span className="text-sm font-medium">Paired</span>
            </>
          ) : (
            <>
              {/* <FaTimes /> */}
              <span className="text-sm font-medium">Coming Soon</span>
            </>
          )}
        </div>
      </div>

      {isPaired && contractAddress && (
        <div className="mt-4">
          <div className="text-gray-300 text-sm mb-2">Contract Address:</div>
          <div className="flex items-center">
            <div className="bg-ftty-purple-darker p-3 rounded-l-lg text-gray-400 flex-1 text-xs md:text-sm truncate">
              {contractAddress}
            </div>
            <button 
              onClick={copyToClipboard}
              className={`${copied ? 'bg-green-600' : 'bg-ftty-orange hover:bg-ftty-orange-light'} p-3 rounded-r-lg transition-colors`}
              title="Copy contract address"
            >
              {copied ? <FaCheckCircle /> : <FaCopy />}
            </button>
          </div>
          <p className="text-gray-400 text-xs mt-2">
            Use this address to add FTTY token to your wallet
          </p>
        </div>
      )}

      {!isPaired && (
        <div className="mt-4">
          <p className="text-gray-400 text-sm">
            FTTY token will be available on {name} in the future.
          </p>
          <div className="mt-4">
            <div className="bg-ftty-purple-darker p-3 rounded-lg text-gray-500 text-center">
              ---------------------------
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

const Chains = () => {
  const sectionRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('opacity-100');
          entry.target.classList.remove('opacity-0');
        }
      },
      { threshold: 0.1 }
    );

    if (sectionRef.current) {
      observer.observe(sectionRef.current);
    }

    return () => {
      if (sectionRef.current) {
        observer.unobserve(sectionRef.current);
      }
    };
  }, []);

  const chains = [
    {
      name: "Ethereum",
      icon: <FaEthereum />,
      isPaired: false,
      color: "text-blue-500"
    },
    {
      name: "Polygon",
      icon: <SiPolygon />,
      isPaired: false,
      contractAddress: "0x68f1e54aedb8F42d2D73AD48E2A56F7914bB79B6",
      color: "text-purple-500"
    },
    {
      name: "Binance Smart Chain",
      icon: <SiBinance />,
      isPaired: true,
      contractAddress: "0x68f1e54aedb8F42d2D73AD48E2A56F7914bB79B6",
      color: "text-yellow-500"
    },
    {
      name: "Solana",
      icon: <SiSolana />,
      isPaired: false,
      color: "text-green-400"
    }
  ];

  return (
    <section id="chains" className="section-spacing">
      <div 
        ref={sectionRef}
        className="container mx-auto px-4 transition duration-1000 opacity-0"
      >
        <div className="text-center mb-16">
          <span className="text-ftty-orange font-medium">Blockchain Compatibility</span>
          <h2 className="text-3xl md:text-5xl font-bold mt-2 mb-6">Available Chains</h2>
          <p className="text-gray-300 max-w-3xl mx-auto">
            FTTY token is designed to work across multiple blockchains, providing flexibility and 
            interoperability for all users. Check which chains are currently supported.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {chains.map((chain, index) => (
            <ChainCard 
              key={index}
              name={chain.name}
              icon={chain.icon}
              isPaired={chain.isPaired}
              contractAddress={chain.contractAddress}
              color={chain.color}
              delay={index * 150}
            />
          ))}
        </div>
        
        <div className="mt-16 text-center">
          <p className="text-gray-300">
            More blockchain integrations coming soon. Join our community to vote on the next chain.
          </p>
          <a 
            href="#community" 
            className="inline-block mt-6 bg-transparent hover:bg-ftty-purple-light text-ftty-orange border border-ftty-orange px-6 py-3 rounded-full font-medium transition-all hover:border-ftty-orange-light"
          >
            Join Community
          </a>
        </div>
      </div>
    </section>
  );
};

export default Chains;