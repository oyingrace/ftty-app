// components/Community.jsx
'use client';
import { useEffect, useRef } from 'react';
import { FaDiscord, FaTelegram, FaTwitter, FaReddit } from 'react-icons/fa';

const Community = () => {
  const sectionRef = useRef(null);
  const formRef = useRef(null);

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

    if (sectionRef.current) {
      observer.observe(sectionRef.current);
    }

    if (formRef.current) {
      observer.observe(formRef.current);
    }

    return () => {
      if (sectionRef.current) {
        observer.unobserve(sectionRef.current);
      }
      if (formRef.current) {
        observer.unobserve(formRef.current);
      }
    };
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    // Clear the email input field
    e.target.elements.email.value = '';
  };
  
  return (
    <section id="community" className="section-spacing relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute top-1/4 right-0 w-64 h-64 rounded-full bg-ftty-orange opacity-10 blur-3xl"></div>
      <div className="absolute bottom-1/4 left-0 w-80 h-80 rounded-full bg-ftty-orange opacity-10 blur-3xl"></div>

      <div className="container mx-auto px-4">
        <div 
          ref={sectionRef}
          className="transition duration-1000 opacity-0 translate-y-10"
        >
          <div className="text-center mb-16">
            <span className="text-ftty-orange font-medium">Join The Revolution</span>
            <h2 className="text-3xl md:text-5xl font-bold mt-2 mb-6">Become Part of Our Community</h2>
            <p className="text-gray-300 max-w-3xl mx-auto">
              Connect with like-minded gamers and traders in our growing community. 
              Get exclusive updates, participate in discussions, and help shape the future of FTTY.
            </p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-16">
            {/* <a href="#" className="col-span-1 card-gradient rounded-xl p-6 flex flex-col items-center justify-center transform transition-all hover:scale-105 hover:shadow-lg group">
              <FaDiscord className="text-ftty-orange text-4xl md:text-5xl mb-4 group-hover:text-white transition-colors" />
              <h3 className="text-xl font-medium">Discord</h3>
              <p className="text-gray-400 text-sm text-center mt-2">Join our server</p>
            </a> */}
            <a href="https://t.me/FattyPattyCoin" className="col-span-1 card-gradient rounded-xl p-6 flex flex-col items-center justify-center transform transition-all hover:scale-105 hover:shadow-lg group">
              <FaTelegram className="text-ftty-orange text-4xl md:text-5xl mb-4 group-hover:text-white transition-colors" />
              <h3 className="text-xl font-medium">Telegram</h3>
              <p className="text-gray-400 text-sm text-center mt-2">Get instant updates</p>
            </a>
            <a href="https://x.com/FattyC35481" className="col-span-1 card-gradient rounded-xl p-6 flex flex-col items-center justify-center transform transition-all hover:scale-105 hover:shadow-lg group">
              <FaTwitter className="text-ftty-orange text-4xl md:text-5xl mb-4 group-hover:text-white transition-colors" />
              <h3 className="text-xl font-medium">Twitter</h3>
              <p className="text-gray-400 text-sm text-center mt-2">Follow our journey</p>
            </a>
            <div className="col-span-1 card-gradient rounded-xl p-6 flex flex-col items-center justify-center">
              <div className="text-ftty-orange text-4xl md:text-5xl mb-4">10K+</div>
              <h3 className="text-xl font-medium">Community Members</h3>
              <p className="text-gray-400 text-sm text-center mt-2">And growing daily</p>
            </div>
          </div>
        </div>

        <div 
          ref={formRef}
          className="card-gradient rounded-xl p-8 md:p-12 max-w-3xl mx-auto transition duration-1000 opacity-0 translate-y-10"
          style={{ animationDelay: '300ms' }}
        >
          <h3 className="text-2xl md:text-3xl font-bold mb-6 text-center">Get Early Access Updates</h3>
          <p className="text-gray-300 mb-8 text-center">
            Be the first to know when FTTY launches and receive exclusive early adopter benefits.
          </p>
          <form onSubmit={handleSubmit} className="flex flex-col md:flex-row gap-4">
            <input 
              type="email" 
              name="email"
              placeholder="Your email address" 
              className="bg-ftty-purple-darker text-white px-6 py-4 rounded-full flex-grow focus:outline-none focus:ring-2 focus:ring-ftty-orange"
              required
            />
            <button 
              type="submit"
              className="bg-ftty-orange hover:bg-ftty-orange-light text-white px-8 py-4 rounded-full font-medium transition-all transform hover:scale-105"
            >
              Subscribe
            </button>
          </form>
          <p className="text-gray-400 text-sm mt-4 text-center">
            We respect your privacy. Unsubscribe at any time.
          </p>
        </div>
      </div>
    </section>
  );
};

export default Community;