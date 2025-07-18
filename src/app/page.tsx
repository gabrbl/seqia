import Image from "next/image";

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col justify-between bg-gradient-to-br from-cyan-900 via-blue-900 to-cyan-700 animate-bg-pan">
      {/* Header */}
      <header className="flex justify-between items-center px-8 py-6">
        <div className="flex items-center gap-4">
          <div className="relative w-16 h-16 flex items-center justify-center">
            <svg width="64" height="64" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" className="drop-shadow-lg">
              {/* Círculo exterior con gradiente */}
              <circle cx="32" cy="32" r="30" fill="url(#paint0_radial)" className="animate-pulse"/>
              
              {/* Forma geométrica central moderna */}
              <g className="animate-spin" style={{animationDuration: '8s'}}>
                <path d="M32 10L42 22L32 34L22 22L32 10Z" fill="url(#paint1_linear)" opacity="0.9"/>
                <path d="M32 30L42 42L32 54L22 42L32 30Z" fill="url(#paint2_linear)" opacity="0.8"/>
              </g>
              
              {/* Elementos decorativos */}
              <circle cx="32" cy="32" r="4" fill="#ffffff" opacity="0.9"/>
              <circle cx="32" cy="22" r="2" fill="#22d3ee" opacity="0.7"/>
              <circle cx="32" cy="42" r="2" fill="#22d3ee" opacity="0.7"/>
              <circle cx="22" cy="32" r="2" fill="#2563eb" opacity="0.7"/>
              <circle cx="42" cy="32" r="2" fill="#2563eb" opacity="0.7"/>
              
              <defs>
                <radialGradient id="paint0_radial" cx="0" cy="0" r="1" gradientUnits="objectBoundingBox" gradientTransform="translate(0.3 0.3) scale(0.9)">
                  <stop stopColor="#22d3ee" stopOpacity="0.3"/>
                  <stop offset="1" stopColor="#2563eb" stopOpacity="0.1"/>
                </radialGradient>
                <linearGradient id="paint1_linear" x1="22" y1="10" x2="42" y2="34" gradientUnits="userSpaceOnUse">
                  <stop stopColor="#22d3ee"/>
                  <stop offset="1" stopColor="#3b82f6"/>
                </linearGradient>
                <linearGradient id="paint2_linear" x1="22" y1="30" x2="42" y2="54" gradientUnits="userSpaceOnUse">
                  <stop stopColor="#3b82f6"/>
                  <stop offset="1" stopColor="#2563eb"/>
                </linearGradient>
              </defs>
            </svg>
          </div>
          <span className="text-white text-3xl font-bold tracking-wider bg-gradient-to-r from-cyan-300 to-blue-400 bg-clip-text text-transparent">Seqia</span>
        </div>
        <nav className="hidden md:flex gap-8 text-white/80 text-lg">
          <a href="#features" className="hover:text-cyan-300 transition-colors">Características</a>
          <a href="#about" className="hover:text-cyan-300 transition-colors">Sobre nosotros</a>
          <a href="#contact" className="hover:text-cyan-300 transition-colors">Contacto</a>
        </nav>
      </header>

      {/* Hero Section */}
      <main className="flex-1 flex flex-col items-center justify-center text-center px-4">
        <h1 className="text-5xl md:text-7xl font-extrabold bg-gradient-to-r from-cyan-300 via-blue-400 to-cyan-500 bg-clip-text text-transparent animate-fade-in-down">
          Agentes personalizados<br />para tu empresa
        </h1>
        <p className="mt-6 text-xl md:text-2xl text-white/80 max-w-2xl animate-fade-in-up">
          Impulsa tu negocio con inteligencia artificial a medida. En <span className="font-bold text-cyan-300">Seqia</span> creamos agentes conversacionales, asistentes virtuales y soluciones IA personalizadas para empresas visionarias.
        </p>
        <a href="#contact" className="mt-10 inline-block px-8 py-4 rounded-full bg-gradient-to-r from-cyan-400 to-blue-500 text-white text-lg font-semibold shadow-lg hover:scale-105 transition-transform animate-fade-in-up">
          Solicita una demo
        </a>
      </main>

      {/* Features Section */}
      <section id="features" className="py-20 px-4 md:px-0 flex flex-col items-center animate-fade-in-up">
        <h2 className="text-3xl md:text-4xl font-bold text-white mb-10">¿Por qué elegir Seqia?</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl w-full">
          <div className="bg-white/10 rounded-xl p-8 backdrop-blur-md border border-cyan-400/20 shadow-lg hover:scale-105 transition-transform">
            <h3 className="text-xl font-semibold text-cyan-300 mb-2">Personalización total</h3>
            <p className="text-white/80">Agentes adaptados a la identidad, necesidades y procesos de tu empresa.</p>
          </div>
          <div className="bg-white/10 rounded-xl p-8 backdrop-blur-md border border-cyan-400/20 shadow-lg hover:scale-105 transition-transform">
            <h3 className="text-xl font-semibold text-cyan-300 mb-2">Tecnología de punta</h3>
            <p className="text-white/80">Utilizamos los últimos avances en IA generativa, NLP y machine learning.</p>
          </div>
          <div className="bg-white/10 rounded-xl p-8 backdrop-blur-md border border-cyan-400/20 shadow-lg hover:scale-105 transition-transform">
            <h3 className="text-xl font-semibold text-cyan-300 mb-2">Soporte experto</h3>
            <p className="text-white/80">Acompañamiento y soporte continuo por nuestro equipo de especialistas.</p>
          </div>
        </div>
      </section>

      {/* About Section */}
      <section id="about" className="py-20 px-4 md:px-0 flex flex-col items-center animate-fade-in-up">
        <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">Sobre Seqia</h2>
        <p className="max-w-3xl text-white/80 text-lg text-center">
          Somos una startup apasionada por la inteligencia artificial y la innovación. Nuestra misión es acercar la IA personalizada a empresas de todos los tamaños, ayudando a transformar la experiencia de clientes y optimizar procesos.
        </p>
      </section>

      {/* Contact Section */}
      <section id="contact" className="py-20 px-4 md:px-0 flex flex-col items-center animate-fade-in-up">
        <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">Contáctanos</h2>
        <form className="w-full max-w-md bg-white/10 rounded-xl p-8 backdrop-blur-md border border-cyan-400/20 shadow-lg flex flex-col gap-4 animate-fade-in-up">
          <input type="text" placeholder="Nombre" className="px-4 py-3 rounded bg-white/80 text-black placeholder:text-gray-500 focus:outline-cyan-400" />
          <input type="email" placeholder="Email" className="px-4 py-3 rounded bg-white/80 text-black placeholder:text-gray-500 focus:outline-cyan-400" />
          <textarea placeholder="¿En qué podemos ayudarte?" className="px-4 py-3 rounded bg-white/80 text-black placeholder:text-gray-500 focus:outline-cyan-400" rows={4} />
          <button type="submit" className="mt-2 px-6 py-3 rounded-full bg-gradient-to-r from-cyan-400 to-blue-500 text-white font-semibold hover:scale-105 transition-transform">Enviar</button>
        </form>
      </section>

      {/* Footer */}
      <footer className="py-8 text-center text-white/60 text-sm animate-fade-in-up">
        © {new Date().getFullYear()} Seqia. Todos los derechos reservados.
      </footer>
    </div>
  );
}

// Animaciones personalizadas con Tailwind (agregar en globals.css):
// .animate-bg-pan, .animate-fade-in-down, .animate-fade-in-up
