module Main exposing (main)

import Browser
import Html
    exposing
        ( Html
        , a
        , br
        , button
        , div
        , figure
        , form
        , h3
        , h5
        , i
        , img
        , input
        , li
        , nav
        , p
        , section
        , span
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( attribute
        , class
        , classList
        , disabled
        , href
        , id
        , placeholder
        , src
        , title
        , type_
        , value
        )
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode as Decode
import Round
import Url.Builder


apiOrigin : String
apiOrigin =
    "https://clickworthiness.herokuapp.com"


questionMarkUrl : String
questionMarkUrl =
    "/images/question-mark-cropped.jpg"


paragraph : String -> Html msg
paragraph content =
    p [] [ text content ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = documentView
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { navbarOpen : Bool
    , headlineInput : String
    , headlineQuery : QueryStatus ClassifyReport
    , showErrors : Bool
    }


type QueryStatus a
    = NoQuery
    | QueryLoading
    | QueryError Http.Error
    | QueryResponse a


type alias ClassifyReport =
    { headline : String
    , isClickbait : Bool
    , probability : Float
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { navbarOpen = False
    , headlineInput = ""
    , headlineQuery = NoQuery
    , showErrors = True
    }


type Msg
    = ToggleSidebar
    | SetHeadlineQuery String
    | SubmitHeadline
    | TestHeadlineResponse (Result Http.Error ClassifyReport)
    | CloseErrorNotification


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSidebar ->
            ( { model | navbarOpen = not model.navbarOpen }, Cmd.none )

        SetHeadlineQuery new ->
            ( { model | headlineInput = new }, Cmd.none )

        SubmitHeadline ->
            ( { model | headlineQuery = QueryLoading }
            , Http.get
                { url =
                    Url.Builder.crossOrigin
                        apiOrigin
                        [ "testHeadline" ]
                        [ Url.Builder.string "headline" model.headlineInput ]
                , expect = Http.expectJson TestHeadlineResponse testHeadlineDecoder
                }
            )

        TestHeadlineResponse res ->
            ( { model | headlineQuery = queryStatus res, showErrors = True }, Cmd.none )

        CloseErrorNotification ->
            ( { model | showErrors = False }, Cmd.none )


queryStatus : Result Http.Error a -> QueryStatus a
queryStatus resp =
    case resp of
        Err err ->
            QueryError err

        Ok a ->
            QueryResponse a


queryLoading : QueryStatus a -> Bool
queryLoading status =
    case status of
        QueryLoading ->
            True

        _ ->
            False


testHeadlineDecoder : Decode.Decoder ClassifyReport
testHeadlineDecoder =
    Decode.field
        "data"
        (Decode.map3
            (\headline clickbait prob ->
                { headline = headline
                , isClickbait = clickbait
                , probability = prob
                }
            )
            (Decode.field "headline" Decode.string)
            (Decode.field "clickbait" Decode.bool)
            (Decode.field "probability" Decode.float)
        )


subscriptions : Model -> Sub Msg
subscriptions _ =
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
    a [ class "navbar-item nav-link is-size-5", href url ] [ text name ]


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
    let
        inputEmpty =
            model.headlineInput == ""
    in
    viewSegment "" "To Click or not to Click?" <|
        div
            []
            [ text """
                Use Machine Learning to see if a headline is for a real news
                article or just "clickbait".
            """
            , form
                [ class "headline-form"
                , onSubmit SubmitHeadline
                ]
                [ div
                    [ class "field has-addons" ]
                    [ div
                        [ class "headline-input control" ]
                        [ input
                            [ class "input"
                            , type_ "text"
                            , placeholder "Test a headline now!"
                            , value model.headlineInput
                            , onInput SetHeadlineQuery
                            ]
                            []
                        ]
                    , div
                        [ class "control" ]
                        [ button
                            [ type_ "submit"
                            , disabled inputEmpty
                            , title <|
                                if inputEmpty then
                                    "Enter in a headline"

                                else
                                    "Test a headline now!"
                            , class "button is-primary"
                            , classList
                                [ ( "is-loading"
                                  , queryLoading model.headlineQuery
                                  )
                                ]
                            ]
                            [ text "Go" ]
                        ]
                    ]
                ]
            , case model.headlineQuery of
                QueryError err ->
                    if model.showErrors then
                        viewHttpError err

                    else
                        text ""

                QueryResponse report ->
                    viewHeadlineReport report

                _ ->
                    -- Since there is no Html.none
                    text ""
            ]


viewHeadlineReport : ClassifyReport -> Html msg
viewHeadlineReport report =
    div
        []
        [ p
            []
            [ text "This headline is probably "
            , if report.isClickbait then
                span
                    [ class "clickbait-text" ]
                    [ text "clickbait "
                    , span
                        [ class "icon" ]
                        [ i [ class "fas fa-exclamation" ] [] ]
                    ]

              else
                span
                    [ class "legitimate-text" ]
                    [ text "legitimate "
                    , span [ class "icon" ] [ i [ class "fas fa-check" ] [] ]
                    ]
            ]
        , p
            []
            [ text "Likelyhood that the headline is clickbait: "
            , text <| Round.round 0 (report.probability * 100.0)
            , text "%"
            ]
        ]


viewHttpError : Http.Error -> Html Msg
viewHttpError err =
    let
        networkErrMsg =
            text """
                There was an error fetching the response. This may be due to
                a problem with your network connection or the server.
                Check you're connection and try again later.
            """

        otherErrMsg =
            text """
                An unexpected error occurred. Sorry for the inconvenience.
            """
    in
    div
        [ class "notification is-danger" ]
        [ button [ class "delete", onClick CloseErrorNotification ] []
        , case err of
            Http.Timeout ->
                networkErrMsg

            Http.NetworkError ->
                networkErrMsg

            _ ->
                otherErrMsg
        ]


viewAboutSegment : Html Msg
viewAboutSegment =
    viewSegment "about" "About" <|
        div
            []
            [ figure
                [ class "image floated-img" ]
                [ img [ src questionMarkUrl ] [] ]
            , paragraph """
                CWaaS (Click-Worthiness as a Service) is a tool capapble of
                distuingishing clickbait and satire from informative headlines
                via ensemble learning.
            """
            , br [] []
            , paragraph """
                A problem plaguing conventional journalism is the need to
                generate profit, just as any business. This has had the adverse
                effect of pushing editors to use eye catching, clickbait-like
                headlines to get more clicks and advertising. While the
                content of the articles still might be informative, it is
                now difficult for readers to discern reputable articles from
                those seeking to entertain their audience. Our goal is to
                attract more attention to this issue by allowing anyone to
                enter a headline and let our algorithm "rate" its level of
                clickbait-ness. Because of this, we hope that visitors will
                begin to analyze the headlines they read in their daily lives,
                seeing how widespread this problem has become.
            """
            ]


viewFAQSegment : Html Msg
viewFAQSegment =
    viewSegment "faq" "FAQ" <|
        div
            []
            [ viewQuestion "Why?" """
                Why not?
            """
            , viewQuestion "But really, why?" """
                This is part of our term project for Machine Learning.
            """
            , viewQuestion "How well does it work?" """
                During testing, our Logistic Classifier scored a 97% accuracy
                rate on clickbait data alone. To further extend the system,
                we sought to train the model on sarcasm and satire data. This
                had the effect of lowering our accuracy to 80%. By removing
                all non-alphanumeric characters, accuracy increased to
                83%. According to our research, classifying satire and
                sarcasm data is a difficult task that requires sentiment
                analysis and other approaches that allow for understanding
                the intent of the author. Even amongst highly complex models,
                accuracy hovers around 88%. Discerning intent and emotion,
                from text, is an incredibly difficult task and one that is
                a highly attractive field of study among machine learners.
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
        div
            [ class "columns" ]
            [ div
                [ class "column" ]
                [ h5 [ class "title is-5" ] [ text "Our team" ]
                , ul
                    []
                    [ li [] [ text "Raphael Henrich" ]
                    , li [] [ text "Zach Peltzer" ]
                    , li [] [ text "James Holland" ]
                    ]
                ]
            , div
                [ class "column" ]
                [ h5 [ class "title is-5" ] [ text "Tools" ]
                , ul
                    []
                    [ li [] [ text "Python" ]
                    , li [] [ text "scikit-learn" ]
                    , li [] [ text "Flask" ]
                    , li [] [ text "Elm" ]
                    , li [] [ text "Bulma" ]
                    , li [] [ text "GitHub Pages" ]
                    , li [] [ text "Heroku" ]
                    ]
                ]
            ]


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
    h3 [ class "is-uppercase title is-3" ] [ text title ]


viewHorizRule : Html Msg
viewHorizRule =
    div [ class "hrule" ] []
