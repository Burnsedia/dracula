import { Link } from "gatsby"
import React, { useState} from "react"
import styled, { css } from "styled-components"
import { IonApp, 
  IonHeader, 
  IonToolbar, 
  IonTitle, 
  IonContent, 
  IonFooter, 
  IonMenu,
  IonList,
  IonListHeader,
  IonMenuToggle,
  IonIcon,
  IonLabel,
  IonPage ,
  IonButtons,
  IonButton,
  IonItem } from '@ionic/react';

/* Core CSS required for Ionic components to work properly */
import '@ionic/react/css/core.css';

/* Basic CSS for apps built with Ionic */
import '@ionic/react/css/normalize.css';
import '@ionic/react/css/structure.css';
import '@ionic/react/css/typography.css';

/* Optional CSS utils that can be commented out */
import '@ionic/react/css/padding.css';
import '@ionic/react/css/float-elements.css';
import '@ionic/react/css/text-alignment.css';
import '@ionic/react/css/text-transformation.css';
import '@ionic/react/css/flex-utils.css';
import '@ionic/react/css/display.css';
const Log = styled.div`
  background-color: #ff5555;
  margin: 0 0 25px;
  padding: 1%;
  text-align: center;
  width: 100%;
  && h1 {
    margin: 0;
  }
  && li {
    font-size: 1.4rem;
    font-weight: bold;
    padding: 0.5rem;
  }
`
const Button = styled.button`
  background: #f8f8f2;
  /* border-radius: 5px; */
  border: 2px solid red;
  color: #bd93f9;
  margin: 0 1em;
  padding: 0.25em 1em;
  width: 100%;
  transition: all ease 100ms;
  &&:hover {
    cursor: pointer;
    color: white;
    background-color: palevioletred;
  }
  ${props =>
    props.primary &&
    css`
      background: palevioletred;
      color: white;
    `};
`

export default function BloodSugarLog() {
  const [bloodSugar, setBloodSugar] = useState("")
  const [bloodSugars, setBloodSugars] = useState([])

  const onSubmit = event => {
    event.preventDefault()
    if (bloodSugar !== "") {
      setBloodSugars([{ title: bloodSugar }, ...bloodSugars])
      setBloodSugar("")
    }
  }
  return (
    <Log>
     <form onSubmit={onSubmit}>
        <label htmlFor="bloodSugar">Log Blood Sugar </label>
        <input
          type="text"
          id="bloodSugar"
          value={bloodSugar}
          placeholder="Enter blood sugar here"
          onChange={event => {
            setBloodSugar(event.target.value)
          }}
        />
        <Button primary={bloodSugar === "" ? false : true} type="submit">
          Submit
        </Button>
      </form>
      <h2>Blood Sugar History</h2>
      <ul>
        {bloodSugars.map((bloodSugar, index) => {
          return <li key={`bloodSugar-${index}`}>{bloodSugar.title}</li>
        })}
      </ul>
    </Log>
  )
}

