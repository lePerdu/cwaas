module Main exposing (main)

import Browser
import Html
    exposing
        ( Html
        , a
        , div
        , input
        , form
        , nav
        , p
        , section
        , span
        , strong
        , text
        )
import Html.Attributes as Attr
    exposing
        ( attribute
        , class
        , classList
        , href
        , id
        , placeholder
        , type_
        , value
        )
import Html.Events as Events exposing (onClick, onInput, onSubmit)


main =
    Browser.document
        { init = init
        , view = documentView
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { navbarOpen : Bool
    , headlineQuery : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { navbarOpen = False
    , headlineQuery = ""
    }


type Msg
    = ToggleSidebar
    | SetHeadlineQuery String
    | SubmitHeadline


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSidebar ->
            ( { model | navbarOpen = not model.navbarOpen }, Cmd.none )

        SetHeadlineQuery new ->
            ( { model | headlineQuery = new }, Cmd.none )

        SubmitHeadline ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


documentView : Model -> Browser.Document Msg
documentView model =
    { title = "CWaaS"
    , body = [ view model ]
    }


view : Model -> Html Msg
view model =
    div
        [ id "root" ]
        [ viewBackground
        , viewNavbar model
        , viewContent model
        ]


viewBackground : Html Msg
viewBackground =
    div [ id "background-image" ] []


viewNavbar : Model -> Html Msg
viewNavbar model =
    let
        open =
            model.navbarOpen
    in
    nav
        [ class "navbar" ]
        [ viewNavbarBrand open, viewNavbarMenu open ]


viewNavbarBrand : Bool -> Html Msg
viewNavbarBrand open =
    div
        [ class "navbar-brand" ]
        [ a
            [ class "navbar-item", href "/" ]
            [ span [ class "logo" ] [ text "CWaaS" ] ]
        , viewNavbarHamburger open
        ]


viewNavbarHamburger : Bool -> Html Msg
viewNavbarHamburger open =
    let
        line =
            span [ attribute "aria-hidden" "true" ] []
    in
    a
        [ classList
            [ ( "navbar-burger", True )
            , ( "is-active", open )
            ]
        , attribute "role" "button"
        , attribute "aria-label" "menu"
        , attribute "aria-expanded" "false"
        , onClick ToggleSidebar
        ]
        [ line, line, line ]


viewNavbarMenu : Bool -> Html Msg
viewNavbarMenu open =
    div
        [ classList
            [ ( "navbar-menu", True )
            , ( "is-active", open )
            ]
        ]
        [ div
            [ class "navbar-end" ]
            (List.map viewNavbarItem
                [ ( "Home", "#" )
                , ( "About", "#about" )
                , ( "FAQ", "#faq" )
                , ( "Credits", "#credits" )
                ]
            )
        ]


viewNavbarItem : ( String, String ) -> Html Msg
viewNavbarItem ( name, url ) =
    a [ class "navbar-item font-secondary is-size-5", href url ] [ text name ]


viewContent : Model -> Html Msg
viewContent model =
    div
        [ class "hero" ]
        [ div
            [ class "container" ]
            [ viewMainSegment model
            , viewAboutSegment
            , viewFAQSegment
            , viewCreditsSegment
            ]
        ]


viewMainSegment : Model -> Html Msg
viewMainSegment model =
    viewSegment "" "To Click or not to Click?" <|
        div
            []
            [ text """
            Use Machine Learning to see if a headline is for a real news
            article or just "clickbait".
        """
            , form
                [ onSubmit SubmitHeadline ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , placeholder "Test a headline now!"
                    , value model.headlineQuery
                    , onInput SetHeadlineQuery
                    ]
                    []
                ]
            ]


viewAboutSegment : Html Msg
viewAboutSegment =
    viewSegment "about" "About" <|
        text """
            CWaaS (Click-Worthiness as a Service) is a tool capapble of
            distuingishing clickbait and satire from informative headlines via
            ensemble learning.
        """


viewFAQSegment : Html Msg
viewFAQSegment =
    viewSegment "faq" "FAQ" <|
        div
            []
            [ viewQuestion "Why?" """
                Because why not?
            """
            , viewQuestion "How well does it work?" """
                Using __, we achieve an accuracy of about __%.
            """
            ]


viewQuestion : String -> String -> Html Msg
viewQuestion question answer =
    p [ class "faq-question" ]
        [ span [ class "has-text-weight-bold" ] [ text question ]
        , text answer
        ]


viewCreditsSegment : Html Msg
viewCreditsSegment =
    viewSegment "credits" "Credits" <|
        text ""


viewSegment : String -> String -> Html Msg -> Html Msg
viewSegment sectId title content =
    section
        [ class "section", id sectId ]
        [ div
            [ class "box" ]
            [ viewSegmentTitle title
            , viewHorizRule
            , content
            ]
        ]


viewSegmentTitle : String -> Html Msg
viewSegmentTitle title =
    span
        [ class "is-uppercase font-secondary is-size-3" ]
        [ text title ]


viewHorizRule : Html Msg
viewHorizRule =
    div [ class "hrule" ] []
