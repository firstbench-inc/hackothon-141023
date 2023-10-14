import React, { useEffect, useState, useContext } from "react";
import Image from "next/image";
import Link from "next/link";

import Style from "./NavBar.module.css";
import { AppContext } from "../../Context/appContext";
import { Model, Error } from "../index";
import images from "../../assets";

const NavBar = () => {
  const menuItems = [
    {
      menu: "All Users",
      link: "/",
    },
    {
      menu: "Chat",
      link: "/",
    },
    {
      menu: "Contact",
      link: "/",
    },
    {
      menu: "Settings",
      link: "/",
    },
    {
      menu: "All Users",
      link: "/",
    },
  ];

  const [Active, setActive] = useState(2);
  const [open, setOpen] = useState(false);
  const [openModel, setOpenModel] = useState(false);
  const [account, userName, connectWallet] = useContext(AppContext);

  return (
    <div className={Style.NavBar}>
      <div className={Style.NavBar_box}>
        <div className={Style.NavBar_box_left}>
          <img src={images.logo} alt="logo" width={50} height={50} />
        </div>
        <div className={Style.NavBar_box_right}>
          <div className={Style.NavBar_box_right_menu}>
            {menuItems.map((el, i) => (
              <div
                onClick={() => setActive(i + 1)}
                key={i + 1}
                className={`${Style.NavBar_box_right_menu_items} ${
                  active === i + 1 ? Style.active_btn : ""
                }`}
              >
                <Link
                  className={Style.NavBar_box_right_menu_items_link}
                  href={el.link}
                ></Link>
              </div>
            ))}
          </div>

          {/*connect wallet*/}
          <div className={Style.NavBar_box_right_connect}>
            {account == "" ? (
              <button onClick={() => connectWallet()}>
                {""}
                <span>Connect Wallet</span>
              </button>
            ) : (
              <button onClick={() => setOpenModel(true)}>
                {""}
                <Image
                  src={userName ? images.accountName : images.create2}
                  width={20}
                  height={20}
                />
                {""}
                <small>{userName || "Create account"}</small>
              </button>
            )}
          </div>
          <div className={Style.NavBar_box_right_open} onClick={setOpen(true)}>
            <Image src={images.open} alt="opem" width={30} height={30} />
          </div>
        </div>
      </div>
      {/*moel comp*/}
      {openModel && (
        <div className={Style.modeBox}>
          <Model
            openModel={setOpenModel}
            title="Welcome to"
            head="Chat app"
            info="hahahaahaha"
            smallInfo="Select your name"
            images={images.hero}
            functionName={createaccount}
          />
        </div>
      )}
    </div>
  );
};

export default NavBar;
