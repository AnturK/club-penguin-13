import { useDispatch } from "common/redux";
import { backendSuspendStart } from "../backend";
import { Button } from "./Button";

export const CpCloseButton = (props, context) => {
  const dispatch = useDispatch(context);

  const close = () => {
    dispatch(backendSuspendStart());
  };

  return (
    <Button className="Button__clubpenguin-close" onClick={close} style={{
      "border-radius": "100%",
      "box-shadow": "0px 0px 16px #000",
      "display": "flex",
      // "text-align": "center",
      "align-items": "center",
      "justify-items": "center",
      "height": "46px",
      "width": "46px",
    }}>
      <div style={{
        "background": "linear-gradient(120deg, #00C1F5, #0280CD)",
        "border": "2px solid #083C6E",
        "border-radius": "100%",
        "color": "#069",
        "display": "inline-block",
        "font-size": "15px",
        "font-weight": "bolder",
        "text-align": "center",
        "margin-left": "-4px",
        "min-height": "42px",
        "min-width": "42px",
        "padding-top": "5px",
      }}>
        <div style={{
          "background": "linear-gradient(120deg, #fff, #ccc)",
          "border": "2px solid #083C6E",
          "border-radius": "100%",
          "color": "#069",
          "display": "inline-block",
          "font-size": "20px",
          "font-weight": "bolder",
          "padding-top": "2px",
          "text-align": "center",
          "vertical-align": "middle",
          "height": "28px",
          "width": "28px",
        }}>
          X
        </div>
      </div>
    </Button>
  );
};
