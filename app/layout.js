// app/layout.js
import './globals.css';
import { AppKitProvider } from '@reown/appkit/react'

export const metadata = {
  title: 'FTTY - Gaming Assets Crypto Marketplace',
  description: 'Purchase gaming assets with FTTY token - the future of gaming economy',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <AppKitProvider
      projectId="5acef91d7967e48a748a4a68f1cb790c"
      networks={[
      ]}
    >
      <body>
        {children}
      </body>
      </AppKitProvider>
    </html>
  );
}