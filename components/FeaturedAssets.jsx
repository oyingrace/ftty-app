// components/FeaturedAssets.jsx
'use client';
import { useEffect, useRef } from 'react';
import { FaEthereum, FaChartLine, FaCoins, FaLayerGroup } from 'react-icons/fa';
import Link from 'next/link';

 const AssetCard = ({ asset, delay }) => {
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

  return (
    <Link 
      href={`/assets/${asset.id}`}
      ref={cardRef}
      className="card-gradient rounded-xl overflow-hidden transition duration-700 opacity-0 translate-y-10 transform hover:scale-105 hover:shadow-lg hover:shadow-ftty-orange/20 group border border-ftty-purple-light hover:border-ftty-orange/40"
    >
      {/* Asset Image */}
      <div className="relative w-full h-48 md:h-56 overflow-hidden bg-ftty-purple-darker">
        <img 
          src={asset.image} 
          alt={asset.name}
          className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-ftty-purple-dark/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
      </div>

      {/* Asset Info */}
      <div className="p-5 md:p-6">
        <h3 className="text-xl md:text-2xl font-semibold mb-4 group-hover:text-ftty-orange transition-colors">
          {asset.name}
        </h3>

        {/* Asset Details Grid */}
        <div className="grid grid-cols-2 gap-4">
          {/* Floor Price */}
          <div className="flex flex-col">
            <div className="flex items-center gap-2 text-gray-400 text-sm mb-1">
              <FaChartLine className="text-ftty-orange" />
              <span>Floor Price</span>
            </div>
            <div className="flex items-center gap-1">
              <FaEthereum className="text-blue-400" />
              <span className="font-semibold text-white">{asset.floorPrice}</span>
            </div>
          </div>

          {/* Top Offer */}
          <div className="flex flex-col">
            <div className="flex items-center gap-2 text-gray-400 text-sm mb-1">
              <FaCoins className="text-ftty-orange" />
              <span>Top Offer</span>
            </div>
            <div className="flex items-center gap-1">
              <FaEthereum className="text-blue-400" />
              <span className="font-semibold text-white">{asset.topOffer}</span>
            </div>
          </div>

          {/* Volume */}
          <div className="flex flex-col">
            <div className="flex items-center gap-2 text-gray-400 text-sm mb-1">
              <FaChartLine className="text-ftty-orange" />
              <span>Volume</span>
            </div>
            <div className="flex items-center gap-1">
              <FaEthereum className="text-blue-400" />
              <span className="font-semibold text-white">{asset.volume}</span>
            </div>
          </div>

          {/* Supply */}
          <div className="flex flex-col">
            <div className="flex items-center gap-2 text-gray-400 text-sm mb-1">
              <FaLayerGroup className="text-ftty-orange" />
              <span>Supply</span>
            </div>
            <span className="font-semibold text-white">{asset.supply}</span>
          </div>
        </div>
      </div>
    </Link>
  );
};

const FeaturedAssets = () => {
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

  // Sample featured assets data - replace with real data from your API
  const featuredAssets = [
    {
      id: '1',
      name: 'Legendary Dragon Sword',
      image: '/sword.jpeg',
      floorPrice: '0.45',
      topOffer: '0.52',
      volume: '12.5',
      supply: '1,000'
    },
    {
      id: '2',
      name: 'Epic Space Helmet',
      image: '/helmet.jpeg',
      floorPrice: '0.28',
      topOffer: '0.35',
      volume: '8.2',
      supply: '2,500'
    },
    {
      id: '3',
      name: 'Rare Magic Staff',
      image: '/staff.jpeg',
      floorPrice: '0.75',
      topOffer: '0.88',
      volume: '25.3',
      supply: '500'
    }
  ];

  return (
    <section id="featured-assets" className="section-spacing relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute top-1/4 left-0 w-64 h-64 rounded-full bg-ftty-orange opacity-10 blur-3xl"></div>
      <div className="absolute bottom-1/4 right-0 w-80 h-80 rounded-full bg-ftty-orange opacity-10 blur-3xl"></div>

      <div 
        ref={sectionRef}
        className="container mx-auto px-4 transition duration-1000 opacity-0"
      >
        <div className="text-center mb-16">
          <span className="text-ftty-orange font-medium">Marketplace</span>
          <h2 className="text-3xl md:text-5xl font-bold mt-2 mb-6">Featured Assets</h2>
          <p className="text-gray-300 max-w-3xl mx-auto">
            Discover the most popular and valuable gaming assets available on the FTTY marketplace.
            Click on any asset to view detailed information and make a purchase.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
          {featuredAssets.map((asset, index) => (
            <AssetCard 
              key={asset.id}
              asset={asset}
              delay={index * 100}
            />
          ))}
        </div>

        <div className="text-center mt-12">
          <Link 
            href="/marketplace"
            className="inline-block bg-transparent hover:bg-ftty-purple-light text-ftty-orange border border-ftty-orange px-8 py-3 rounded-full text-lg font-medium transition-all hover:border-ftty-orange-light hover:scale-105"
          >
            View All Assets
          </Link>
        </div>
      </div>
    </section>
  );
};

export default FeaturedAssets;

