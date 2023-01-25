
import { Link } from "gatsby"
import React from "react"
import styled from "styled-components"
import { IonApp, 
  IonHeader, 
  IonTitle, 
  IonToolbar,
  } from '@ionic/react';

const Nav = styled.div`
  background-color: #44475a;
  margin: 0 0 2rem;
  padding: 1rem;
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

export default function Navbar() {
  return (
    <IonMenu content-id="main-content">
    <IonHeader>
      <IonToolbar color="primary">
        <IonTitle>Menu</IonTitle>
      </IonToolbar>
    </IonHeader>
    </IonMenu>
  )
 };

