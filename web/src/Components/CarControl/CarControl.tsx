import { useState } from 'react';
import { SimpleGrid, ActionIcon } from '@mantine/core';
import { fetchNui } from '../../utils/fetchNui';
//@ts-ignore
import { useNuiEvent } from '../../hooks/useNuiEvent';

const renderButton = (buttonState: any, index: any, handleClick: (index: number, state: number) => void, loading: number) => {
  return (
    <ActionIcon
      disabled={buttonState.disabled}
      loading={loading === index}
      style={{
        cursor: "default",
        transition: "background-color 150ms"
      }}
      color={buttonState.state === 2 ? 'blue' : 'dark.6'}
      className='actionBtn'
      key={index}
      variant="filled"
      size="3rem"
      onClick={() => handleClick(index, buttonState.state)}
    >
      <img style={{ height: "2rem" }} src={`./icons/${index.includes("seat") ? 'seat' : index}.png`} />
    </ActionIcon>
  );
}

export default function CarControl({ buttonStates, setButtonStates }: { buttonStates: any, setButtonStates: any }) {
  //@ts-ignore
  const [loading, setLoading] = useState<number>(-1);

  const handleClick = (index: number, state: number) => {
    setLoading(index)
    fetchNui('controlClicked', { index: index, state: state })
      .then(buttonState => {
        console.log('CLICK')
        setButtonStates((prevStates: any) => {
          const newStates = { ...prevStates };
          newStates[index] = {
            ...newStates[index],
            state: buttonState,
          };

          return newStates;
        });
      })

      .finally(() => setLoading(-1))
  };

  const buttonStateArray = Object.entries(buttonStates);

  return (
    <SimpleGrid p="1rem" cols={6} spacing="lg" >
      {!buttonStates}

      {buttonStateArray.map(([key, buttonState]: [string, any]) => (
        renderButton(buttonState, key, handleClick, loading)
      ))}
    </SimpleGrid>
  );
}