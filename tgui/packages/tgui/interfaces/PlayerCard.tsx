import { range } from "common/collections";
import { Color } from "common/color";
import { BooleanLike, pureComponentHooks } from "common/react";
import { SFC } from "inferno";
import { resolveAsset } from "../assets";
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Stack } from "../components";
import { CpButton } from "../components/CpButton";
import { CpCloseButton } from "../components/CpCloseButton";
import { CpWindow } from "../layouts/CpWindow";

// WHAT ARE THOOOOOSE
// https://stackoverflow.com/a/38648660/1910744
if (typeof SVGElement.prototype.focus === 'undefined') {
  SVGElement.prototype.focus = () => {};
}

type InventoryItem = {
  index: number,
  club_penguin_id: number,
};

type Inventory = Record<string, InventoryItem[]>;

type PlayerCardData = {
  name: string,
  color: string,
  worn_items: number[],
  can_edit_inventory: BooleanLike,
  inventory?: Inventory,
};

const CARD_ASSET_STYLE: CSSProperties = {
  "position": "absolute",
  "top": "50%",
  "transform": "translateY(-50%)",
  "width": "100%",
};

const cardAssetFromId = (id: number) => {
  return `https://icer.ink/media8.clubpenguin.com/game/items/images/paper/image/600/${id}.png`;
};

const inventoryAssetFromId = (id: number) => {
  // return `https://icer.ink/media1.clubpenguin.com/avatar/icon/600/${id}.png`;
  return `https://play.cprewritten.net/assets/content/global/clothing//icons/${id}@3x-0.png`;
};

const CardAsset = (props: {
  fade?: boolean,
  url: string,
}) => {
  return (
    <img
      src={props.url}
      className={props.fade ? "PlayerCard__CardAsset-fade" : ""}
      style={CARD_ASSET_STYLE}
    />
  );
};

CardAsset.defaultHooks = pureComponentHooks;

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
    <svg width="343" height="400" style={CARD_ASSET_STYLE}>
      <filter id="greyscale">
        <feColorMatrix type="matrix" values={matrix} />
      </filter>
      <image x="0" y="0" xlinkHref={resolveAsset("penguin-body.png")} filter="url(#greyscale)" width="343" height="400" />
    </svg>
  );
};

const PLAYER_CARD_WIDTH = 400;
const INVENTORY_WIDTH = 425;

const PlayerCardComponent = (props, context) => {
  const { data, act } = useBackend<PlayerCardData>(context);

  return (
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

      <Stack.Item width="90%" grow position="relative">
        <Box style={{
          "background": "#01529B",
          "border-radius": "20px",
          "overflow": "hidden",
          "position": "relative",
          "height": "100%",
          "width": "95%",
        }}>
          <PenguinBody color={data.color} />
          <CardAsset url={resolveAsset("penguin-features.png")} />

          {/* Items on Club Penguin have a fade in */}
          {/* ...and it looks AWFUL. */}
          {data.worn_items.map(itemId => (
            <CardAsset key={itemId} url={cardAssetFromId(itemId)} fade />
          ))}
        </Box>

        {!!data.can_edit_inventory && !data.inventory && (
          <Button
            className="PlayerCard__inventory-button"
            onClick={() => act("open_inventory")}
          >
            <Box className="PlayerCard__inventory-button__inner" />
          </Button>
        )}
      </Stack.Item>
    </Stack>
  );
};

const INVENTORY_COLUMNS = 3;
const INVENTORY_ROWS = 4;
const INVENTORY_CELL_SIZE = 90;

const InventoryComponent: SFC<{ inventory: Inventory }> = (props, context) => {
  const { data, act } = useBackend<PlayerCardData>(context);
  const { inventory } = props;

  // EVENT TODO: Filters, maybe. Dropdowns are going DOWN,
  // when they need to go UP
  const [filterSlot, setFilterSlot]
    = useLocalState<string | null>(context, "filterSlot", null);

  const [rowOffset, setRowOffset] = useLocalState<number>(context, "rowOffset", 0);

  const items: InventoryItem[] = filterSlot
    ? inventory[filterSlot]
    : Object.values(inventory).flat();

  const totalRows = Math.ceil(items.length / INVENTORY_ROWS);

  return (
    <Stack
      width="100%"
      height="100%"
      backgroundColor="#eee"
      vertical
    >
      <Stack.Item height="95%">
        <Stack width="100%" fill pt={5} px={5}>
          <Stack.Item width="100%" height="100%">
            <Stack width="100%" vertical fill justify="center">
              {range(0, INVENTORY_ROWS).map(rowId => {
                return (
                  <Stack.Item key={rowId} height={`${INVENTORY_CELL_SIZE}px`}>
                    <Stack
                      justify="space-around"
                      width="100%"
                    >
                      {range(0, INVENTORY_COLUMNS).map(columnId => {
                        const item
                          = items[
                            (rowOffset + rowId * INVENTORY_COLUMNS)
                              + columnId
                          ];

                        return (
                          <Button
                            className="Button__white-inverse"
                            key={columnId}
                            height={`${INVENTORY_CELL_SIZE}px`}
                            width={`${INVENTORY_CELL_SIZE}px`}
                            style={{
                              "border-radius": "10%",
                              "border": "3px solid #aaa",
                              "visibility": item ? "": "hidden",
                            }}
                            onClick={() => {
                              act("toggle", {
                                index: item.index,
                              });
                            }}
                          >
                            {item && (
                              <Box
                                as="img"
                                src={inventoryAssetFromId(item.club_penguin_id)}
                                width="100%"
                                height="auto"
                                mt={1}
                              />
                            )}
                          </Button>
                        );
                      })}
                    </Stack>
                  </Stack.Item>
                );
              })}
            </Stack>
          </Stack.Item>

          <Stack.Item width="45px" height="100%" ml={2} position="relative">
            <Box
              position="absolute"
              backgroundColor="#ccc"
              height="95%"
              width="100%"
              mt={2}
              mx={1}
            />

            <CpButton onClick={() => {
              setRowOffset(Math.max(0, rowOffset - 1));
            }}>
              <Box style={{
                "transform": "scale(2.1, 1.3) translateY(-2px)",
              }}>
                🔼
              </Box>
            </CpButton>

            <CpButton onClick={() => {
              if (rowOffset < totalRows) {
                setRowOffset(rowOffset + 1);
              }
            }} native={{
              "style": {
                "position": "absolute",
                "bottom": 0,
              },
            }}>
              <Box style={{
                "transform": "scale(2.1, 1.3)",
              }}>
                🔽
              </Box>
            </CpButton>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const PlayerCard = (props, context) => {
  const { data, act } = useBackend<PlayerCardData>(context);
  const { inventory } = data;

  if (inventory) {
    // SIIIIIGH LOOKS LIKE WE GOTTA DO THIS THE HARD WAY
    return (
      <CpWindow
        width={PLAYER_CARD_WIDTH + INVENTORY_WIDTH}
        height={500}
      >
        {/* Uses stacks improperly LIKE A BOSS */}
        <Stack fill>
          <Stack.Item width={`${PLAYER_CARD_WIDTH}px`}>
            <PlayerCardComponent />
          </Stack.Item>

          <Stack.Item width={`${INVENTORY_WIDTH}px`}>
            <InventoryComponent inventory={inventory} />
          </Stack.Item>
        </Stack>
      </CpWindow>
    );
  } else {
    return (
      <CpWindow width={PLAYER_CARD_WIDTH} height={500}>
        <PlayerCardComponent />
      </CpWindow>
    );
  }
};
