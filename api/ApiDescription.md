# Eldritch Horror Cards (API)

`root url: URL: 82.202.236.16/api/mobile_app/v1`

## 1.  Пользователь нажимает на кнопку "Старт"

* type: `post`
* endpoint:  `/games`
* params example: `{ user_uid: "ЭТО ПОКА НЕ ОБЯЗАТЕЛЬНЫЙ ПАРАМЕТР" }` 
* response: 
    * id игры - он будет дальше везде подставляться в запросах
    * token игры
    * локация текущей экспедиции
``` JSON
{
      "id": "1",
      "token": "t6y7u8i9o9u7y6t5",
      "expedition_location": "himalayas"
}
```

## 2 Показывает пользователю список доступных дополнений

* type: `get`
* endpoint `/game_sets`
* response:
    * id дополнения
    * идентификатор дополнения

``` JSON
[
    {
        "id": 2,
        "identity": "under_the_pyramids",
        "name": "Под пирамидами"
    },
    {
        "id": 3,
        "identity": "mountains_of_madness",
        "name": "Хребты безумия"
    },
    {
        "id": 4,
        "identity": "signs_of_carcosa",
        "name": "Знаки Каркозы"
    },
    {
        "id": 5,
        "identity": "forsaken_lore",
        "name": "Забытые тайны"
    }
]
```

## 3 Пользователь выбрал несколько дополнений

Отправляем запрос, чтобы сервер подготовил данные.

* type: `put`
* endpoint: `/games/id/[ИД игры]`
* body params: 
``` JSON
 { 
    "game": { "game_set_identity" : ["2", "5"] }
 }
```
* response: приходит техническая инфа, которая нам не нужна по сути, главное получить статус `200`.

## 4 Запрос доступных Древних

Отправив запрос 3, можно получить монстров. Если запрос 3 не отправили, придет пустой список.

* type: `get`
* enpoint: `/ancients`
* url params: `game_id=[ИД игры передаем]`
* response: список монстров
``` JSON
[
    {
        "id": 1,
        "identity": "abhoth",
        "name": "Абхот"
    },
    {
        "id": 2,
        "identity": "azathoth",
        "name": "Азатот"
    },
    {
        "id": 3,
        "identity": "cthulhu",
        "name": "Ктулху"
    },
    {
        "id": 6,
        "identity": "nephren-ka",
        "name": "Нефрен-Ка"
    },
    {
        "id": 7,
        "identity": "shub-niggurath",
        "name": "Шуб-Ниггурат"
    },
    {
        "id": 8,
        "identity": "yig",
        "name": "Йиг"
    },
    {
        "id": 9,
        "identity": "yog-sothoth",
        "name": "Йог-Сотот"
    }
]
```

## 5 Пользователь выбирает Древнего.

* type: `put`
* endpoint: `games/[ИД ИГРЫ]`
* body params: 
``` JSON
{ 
    "game": { "ancient_id": 3 }
}
```
* response: приходит техническая инфа, которая нам не нужна по сути, главное получить статус `200`.

## 6 Показываем доступные типы карт

* type: `get`
* endpoint: `/cards`
* params:  `{ "game_id": "1" }`
* response:
``` JSON
{
    "avaliable_card_types": [
        [
            "general_contacts",                      # обычные контакты
            "other_world_contacts",                  # порталы
            "expedition_location_heart_of_africa",   #локация текущей экспедиции          
            "research_contact_abhoth",               # улики для Абхота
            "contact_in_america",                    # контакты в америке
            "contact_in_europe",                     # контакты в увропе 
            "contact_in_asia_australia",             # контакты в австралии
            "contact_in_egypt",                      # контакты в египте
            "contact_in_africa",                     # контакты в африке
            "special_contact_spawn_of_abhoth",       # специальный контакт Отродье Абхоте
            "special_contact_deep_caverns"           # спеиальный контакт глубокие пещеры
        ]
    ]
}
```

### 6.1	Пользователь выбрал обычный контакт
* type: `get`
* endpoint: `/general_contacts`
* params: `{ "game_id": "1" }
* response: 
``` JSON
{
    "city": "Прежде чем вынести украденный товар из магазина, вы хотите убедится, что вас ",
    "wilderness": "Перед вами лежат останки давно погибшего исследователя. Кое-что из ..",
    "sea": "Натолкнувшись на обломки кораблекрушения, вы ищите выживших или хотя .."
}
```

### 6.2 Пользователь выбрал портал
* type: `get`
* endpoint: `/other_world_contacts`
* params: `{ "game_id": "1" }
* response: 
``` JSON
{
    "initial_effect": "Вы попали в комнату, полную металических цилиндров....",
    "pass_effect": "Мозги из цилиндров объясняют, как путешествовать между .....",
    "fail_effect": "Лишённые тел мозги требуют, чтобы вы остались. Они ....."
}
```

### 6.3 Пользователь выбрал улику
* type: `get`
* endpoint: `/research_contacts`
* params: 
``` JSON
{
     "game_id": "1",
     "contact_type": "research_contact_nephren-ka"
}
```

* response:
``` JSON
 {
    "city": "Вас наняли доставить пакет отставному профессору (глаз)...",
    "wilderness": "Встретив на дороге растерянного путника, вы предлагаете ему помощь (руки -2)..",
    "sea": "На море бушует страшная буря, и в завыванияхветра вам слышится неземное пение."
}
```
<b>Если не созданы улики для данного Древнего:</b>
``` JSON
{
    "city": null,
    "wilderness": null,
    "sea": null
}
```

### 6.4 Пользователь выбрал экспедицию
* type: `get`
* endpoint: `/expedition_contacts`
* params: 
``` JSON 
{
  "game_id": "1",
  "contact_type": "expedition_location_pyramid"
}
```

* response:
``` JSON
{
    "initial_effect": "Бандиты крепко связывают вас и оставляют....",
    "pass_effect": "Вы видите, что оказались в храме Сфинкса: снизте безысходность на 1...",
    "fail_effect": "Пытаясь освободиться, вы чувствуете, как руки живых .."
}
```
<b>Если не созданы экспедиции для данной локации:</b>
```JSON
{
    "initial_effect": null,
    "pass_effect": null,
    "fail_effect": null
}
```
### 6.5 Пользователь выбирает особый контакт
* type: `get`
* endpoint: `/special_contacts`
* params: 
``` JSON 
{
  "game_id": "1",
  "contact_type": "special_contact_the_black_wind"
}
```
* response:
``` JSON
{
    "identity": "special_contact_the_black_wind",
    "title": "Черный вихрь",
    "initial_effect": "На мили вокруг бушует песчаная буря, в центре ..",
    "pass_effect": "Кошка приводит вас к глазу бури. Вы ощущаете божественную ..",
    "fail_effect": "Угнаться за кошкой невозможно, и песок забивает вам глаза: ..."
}
```
<b>Если еще не созданы особые контакты с данным `???` </b>
``` JSON
    "identity": null,
    "title": "",
    "initial_effect": null,
    "pass_effect": null,
    "fail_effect": null
}
```
### 6.6 Пользователь выбирает конткт в локации
* type: `get`
* endpoint: `/location_contacts`
* params: 
``` JSON 
{
  "game_id": "1",
  "contact_type": "contact_in_asia_australia"
}
```
* response:
``` JSON
{
    "location_one": "Шанхай",
    "content_one": "Вы видите, как рыбообразный человек утягивает молодого ...",
    "location_two": "Токио",
    "content_two": "В Токийском университете хранится перевод свитка 'Дао ...",
    "location_three": "Сидней",
    "content_three": "Констебль замечает, что вы засмотрелись на забытое кем-то.."
}
```