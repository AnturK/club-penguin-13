import { Color } from "common/color";
import { resolveAsset } from "../assets";
import { useBackend } from "../backend";
import { Box, Stack } from "../components";
import { CpCloseButton } from "../components/CpCloseButton";
import { CpWindow } from "../layouts/CpWindow";

type PlayerCardData = {
  name: string,
  color: string,
};

const CARD_ASSET_STYLE: CSSProperties = {
  "position": "absolute",
  "top": "50%",
  "transform": "translateY(-50%)",
  "width": "100%",
};

const assetForItemId = (id) => {
  return `https://icer.ink/media8.clubpenguin.com/game/items/images/paper/image/600/${id}.png`;
};

const CardAsset = (props: {
  url: string,
}) => {
  return (<img src={props.url} style={CARD_ASSET_STYLE} />);
};

const PenguinBody = (props: {
  color: string,
}) => {
  // const matrix =
  const color = Color.fromHex(props.color);
  const matrix = `
    ${color.r / 255} 0 0 0 0
    0 ${color.g / 255} 0 0 0
    0 0 ${color.b / 255} 0 0
    0 0 0 1 0
  `;

  return (
    <svg width="360" height="400" style={CARD_ASSET_STYLE}>
      <filter id="greyscale">
        <feColorMatrix type="matrix" values={matrix} />
      </filter>
      <image x="0" y="0" xlinkHref={resolveAsset("penguin-body.png")} filter="url(#greyscale)" width="360" height="400" />
    </svg>
  );
};

export const PlayerCard = (props, context) => {
  const { data, act } = useBackend<PlayerCardData>(context);

  return (
    <CpWindow
      width={400}
      height={500}
    >
      <Stack vertical fill align="center" pb={3}>
        <Stack.Item width="100%" maxHeight="50px" style={{
          "margin-top": "20px",
        }}>
          <Stack fill align="center">
            <Stack.Item grow style={{
              "font-size": "21px",
              "font-weight": "bold",
              "padding-left": "20px",
              "text-align": "center",
            }}>
              {data.name}
            </Stack.Item>

            <Stack.Item style={{
              "margin-right": "10px",
            }}>
              <CpCloseButton />
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <Stack.Item width="90%" grow>
          <Box style={{
            "background": "#01529B",
            "border-radius": "20px",
            "overflow": "hidden",
            "position": "relative",
            "height": "100%",
            "width": "100%",
          }}>
            <PenguinBody color={data.color} />
            <CardAsset url={resolveAsset("penguin-features.png")} />
            <CardAsset url={assetForItemId(429)} />
          </Box>
        </Stack.Item>
      </Stack>
    </CpWindow>
  );
};
