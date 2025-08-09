import React from "react";
import ChatBox from "./components/ChatBox";
import "./App.css";

export default function App() {
  return (
    <div className="app">
      <div className="app-header">
        <div className="header-content">
          <div className="logo">
            <span className="logo-icon">🤖</span>
            <h1 className="logo-text">AI Document Assistant</h1>
          </div>
          <p className="tagline">Ask questions about your documents with AI-powered intelligence</p>
        </div>
      </div>
      
      <main className="main-content">
        <div className="container">
          <ChatBox />
        </div>
      </main>
      
      <footer className="app-footer">
        <p>&copy; 2024 AI Document Assistant. Powered by AWS Bedrock.</p>
      </footer>
    </div>
  );
}
