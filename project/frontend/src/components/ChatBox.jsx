import React, { useState } from "react";
import "./ChatBox.css";

export default function ChatBox() {
  const [question, setQuestion] = useState("");
  const [conversations, setConversations] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  const API_URL = import.meta.env.VITE_API_URL;

  async function handleAsk() {
    if (!question.trim()) return;
    
    setIsLoading(true);
    const currentQuestion = question;
    setQuestion("");
    
    // Add user message to conversation
    setConversations(prev => [...prev, { type: 'user', content: currentQuestion }]);
    
    try {
      const res = await fetch(`${API_URL}/api/ask`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ question: currentQuestion }),
      });
      
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      
      const data = await res.json();
      
      // Add AI response to conversation
      setConversations(prev => [...prev, { type: 'ai', content: data.answer }]);
    } catch (error) {
      console.error('Error asking question:', error);
      setConversations(prev => [...prev, { 
        type: 'error', 
        content: `Error: ${error.message}` 
      }]);
    } finally {
      setIsLoading(false);
    }
  }

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleAsk();
    }
  };

  return (
    <div className="chatbox">
      <div className="chat-header">
        <h2>💬 Ask me anything about your documents</h2>
        <p>Type your question below and I'll help you find the answer</p>
      </div>
      
      <div className="chat-messages">
        {conversations.length === 0 ? (
          <div className="welcome-message">
            <div className="welcome-icon">🚀</div>
            <h3>Welcome to AI Document Assistant!</h3>
            <p>Start by asking a question about your documents. I'm here to help!</p>
          </div>
        ) : (
          conversations.map((msg, index) => (
            <div key={index} className={`message ${msg.type}`}>
              <div className="message-avatar">
                {msg.type === 'user' ? '👤' : msg.type === 'ai' ? '🤖' : '⚠️'}
              </div>
              <div className="message-content">
                <div className="message-text">{msg.content}</div>
                <div className="message-time">
                  {new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                </div>
              </div>
            </div>
          ))
        )}
        
        {isLoading && (
          <div className="message ai loading">
            <div className="message-avatar">🤖</div>
            <div className="message-content">
              <div className="typing-indicator">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
          </div>
        )}
      </div>
      
      <div className="chat-input-container">
        <div className="input-wrapper">
          <textarea
            value={question}
            onChange={(e) => setQuestion(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="Type your question here... (Press Enter to send)"
            className="chat-input"
            rows="2"
            disabled={isLoading}
          />
          <button 
            onClick={handleAsk} 
            className={`send-button ${!question.trim() || isLoading ? 'disabled' : ''}`}
            disabled={!question.trim() || isLoading}
          >
            {isLoading ? '⏳' : '📤'}
          </button>
        </div>
      </div>
    </div>
  );
}
