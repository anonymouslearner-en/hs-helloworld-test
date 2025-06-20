import { useEffect, useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

function App() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    localStorage.setItem("YouFoundTheEgg", "Cheers from Colgne");
  });

  return (
    <>
      <div>
        <img src={viteLogo} className="logo" alt="Vite logo" />

        <img src={reactLogo} className="logo react" alt="React logo" />
      </div>
      <h1>Hello World</h1>
      <p>negitorodon edition</p>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>Simple Web App for homeserver testing 🙂</p>
      </div>
    </>
  );
}

export default App;
