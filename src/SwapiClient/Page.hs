module SwapiClient.Page
  ( Page (Page, NoPage)
  , Index
    ( Index
    , iCount
    , iNextPage
    , iPreviousPage
    , iResults
    )
  ) where

--------------------------------------------------------------------------------

import Data.Aeson.Types (FromJSON (parseJSON), Parser, ToJSON (toJSON),
                         Value (Null, String))
import Data.Kind        (Type)
import Data.Map.Strict  qualified as Map (fromList, lookup)
import Data.Text.Read   qualified as Text.Read (decimal)
import TextShow         qualified as Text.Show (showt)

--------------------------------------------------------------------------------

import SwapiClient.Url  (UrlData (UrlData, udParams, udSubdir))
import SwapiClient.Url  qualified as Url (urlDataToUrl, urlToUrlData)

--------------------------------------------------------------------------------
-- Data types

{- FIXME: `Index` can have a page of a different resource. e.g `Index`
has `StarshipPage`, which doesn't make sense. -}
data Page
  = Page Int
  | NoPage
  deriving stock (Eq, Show)

data Index a = Index
  { iCount        :: Int
  , iNextPage     :: Page
  , iPreviousPage :: Page
  , iResults      :: [a]
  }
  deriving stock Show

--------------------------------------------------------------------------------
-- Instances

instance FromJSON (Page :: Type) where
  parseJSON :: Value -> Parser Page
  parseJSON val =
    case val of
      String pageUrl ->
        case Url.urlToUrlData pageUrl of
          Just urlData ->
            case Map.lookup "page" (udParams urlData) of
              Just pageNum  ->
                case Text.Read.decimal pageNum of
                  Right (pageNum', "") ->
                    pure . Page $ pageNum'
                  Right _ -> fail "ERROR: Invalid page number format."
                  Left e -> fail e
              Nothing -> pure NoPage
          Nothing -> fail "ERROR: Unable to strip base URL. It might be invalid."

      Null -> pure NoPage
      _ -> fail "ERROR: This isn't part of the API spec"

instance ToJSON (Page :: Type) where
  toJSON :: Page -> Value
  toJSON = String . maybe "null" Url.urlDataToUrl . pageToUrlData

--------------------------------------------------------------------------------
-- Functions

pageToUrlData :: Page -> Maybe UrlData
pageToUrlData =
  \case
    Page pageNum ->
      Just $
        UrlData
          { udSubdir = ["people"]
          , udParams = Map.fromList
            [ ("page", Text.Show.showt pageNum)
            , ("format", "json")]
          }

    NoPage -> Nothing
