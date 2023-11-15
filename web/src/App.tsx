import './App.css'
import { Paper, Button, Skeleton } from '@mantine/core';
import CarControl from './Components/CarControl/CarControl';
import Draggable from 'react-draggable';
import { useNuiEvent } from './hooks/useNuiEvent';
import { useState, useEffect } from 'react';
import { isEnvBrowser } from './utils/misc';
import { fetchNui } from './utils/fetchNui';

const options = {
  "ignition": {
    state: 1,
    disabled: false,
  },
  "hazard": {
    state: 1,
    disabled: false,
  },
  "parkbrake": {
    state: 1,
    disabled: false,
  },
  "fronthood": {
    state: 1,
    disabled: false,
  },
  "rearHood": {
    state: 1,
    disabled: false,
  },
  "interiorLight": {
    state: 1,
    disabled: false,
  },
  "windowFrontLeft": {
    state: 1,
    disabled: false,
  },
  "doorFrontLeft": {
    state: 1,
    disabled: false,
  },
  "seatFrontLeft": {
    state: 1,
    disabled: false,
  },
  "seatFrontRight": {
    state: 1,
    disabled: false,
  },
  "doorFrontRight": {
    state: 1,
    disabled: false,
  },
  "windowFrontRight": {
    state: 1,
    disabled: false,
  },
  "windowRearLeft": {
    state: 1,
    disabled: false,
  },
  "doorRearLeft": {
    state: 1,
    disabled: false,
  },
  "seatRearLeft": {
    state: 1,
    disabled: false,
  },
  "seatRearRight": {
    state: 1,
    disabled: false,
  },
  "doorRearRight": {
    state: 1,
    disabled: false,
  },
  "windowRearRight": {
    state: 1,
    disabled: false,
  },
}

export default function App() {
  const [buttonStates, setButtonStates] = useState(options);

  const [visible, setVisible] = useState<boolean>(false);

  fetchNui('uiloaded')

  useNuiEvent('visibility', (data) => {
    setVisible(data.display);
    if (!data.display) fetchNui("hideFrame")
  })

  useNuiEvent('restart', () => {
    const updatedButtonStates = Object.keys(options).reduce((acc: any, key: any) => {
      acc[key] = {
        state: 1,
        disabled: false,
      };
      
      return acc;
    }, {});
  
    setButtonStates(updatedButtonStates);
  });
  

  useEffect(() => {
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Backspace", "Escape"].includes(e.code)) {
        setVisible(!visible)
        if (!isEnvBrowser()) fetchNui("hideFrame");
      }
    }

    window.addEventListener("keydown", keyHandler)

    return () => window.removeEventListener("keydown", keyHandler)
  }, [visible, setVisible])

  return (<>
    {isEnvBrowser() && (
      <Button onClick={() => setVisible(!visible)} style={{ position: "absolute", top: "20%", left: "50%", zIndex: 999 }}> Button </Button>
    )}

    <div style={{ height: '100vh', visibility: visible ? "visible" : "hidden", opacity: visible ? 1 : 0, transition: `visibility 0s linear ${visible ? '0s' : '0.5s'}, opacity .6s ease-in-out` }}>
      <Draggable
        cancel=".actionBtn"
        bounds="parent"
        axis="both"
        handle=".wrapper"
      >
        <Paper className="wrapper" radius={12} withBorder style={{
          cursor: 'move',
          position: "absolute",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          padding: "1rem",
        }}>
          {!buttonStates ? (
            <Skeleton visible />
          ) : (
            <CarControl buttonStates={buttonStates} setButtonStates={setButtonStates}></CarControl>
          )}

        </Paper>
      </Draggable>
    </div>
  </>


  );
}