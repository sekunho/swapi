module SwapiClient.Id
  ( FilmId (FilmId)
  , HomeworldId (HomeworldId)
  , SpeciesId (SpeciesId)
  , VehicleId (VehicleId)
  , StarshipId (StarshipId)
  , PersonId (PersonId)
  , unFilmId
  , unHomeworldId
  , unPersonId
  , unSpeciesId
  , unStarshipId
  , unVehicleId
  ) where

--------------------------------------------------------------------------------
-- External

import Data.Aeson
  ( FromJSON (parseJSON)
  , ToJSON (toJSON)
  , Value (String)
  )
import Data.Aeson qualified as Aeson (withText)
import Data.Aeson.Types (Parser)
import Data.Kind (Type)
import Data.Text (Text)
import TextShow qualified as Text.Show (showt)

--------------------------------------------------------------------------------
-- Internal

import SwapiClient.Url
  ( Resource
      ( Film
      , Planet
      , Species
      , Vehicle
      , Starship, People
      )
  )
import SwapiClient.Url qualified as Url (resourceUrl, getId)

--------------------------------------------------------------------------------
-- Data types

newtype FilmId = FilmId Int
  deriving Show

newtype HomeworldId = HomeworldId Int
  deriving Show

newtype SpeciesId = SpeciesId Int
  deriving Show

newtype VehicleId = VehicleId Int
  deriving Show

newtype StarshipId = StarshipId Int
  deriving Show

newtype PersonId = PersonId Int
  deriving Show

--------------------------------------------------------------------------------
-- Instances

instance FromJSON (FilmId :: Type) where
  parseJSON :: Value -> Parser FilmId
  parseJSON =
    Aeson.withText "FilmID" $
      \filmUrl ->
        case Url.getId filmUrl of
          Right intId -> pure . FilmId $ intId
          Left e -> fail e

instance ToJSON (FilmId :: Type) where
  toJSON :: FilmId -> Value
  toJSON = String . buildFilmUrl

instance FromJSON (HomeworldId :: Type) where
  parseJSON :: Value -> Parser HomeworldId
  parseJSON =
    Aeson.withText "HomeworldId" $
      \homeworldUrl ->
        case Url.getId homeworldUrl of
          Right intId -> pure . HomeworldId $ intId
          Left e -> fail e

instance ToJSON (HomeworldId :: Type) where
  toJSON :: HomeworldId -> Value
  toJSON = String . buildPlanetUrl

instance FromJSON (SpeciesId :: Type) where
  parseJSON :: Value -> Parser SpeciesId
  parseJSON =
    Aeson.withText "SpeciesId" $
      \speciesUrl ->
        case Url.getId speciesUrl of
          Right intId -> pure . SpeciesId $ intId
          Left e -> fail e

instance ToJSON (SpeciesId :: Type) where
  toJSON :: SpeciesId -> Value
  toJSON = String . buildSpeciesUrl

instance FromJSON (VehicleId :: Type) where
  parseJSON :: Value -> Parser VehicleId
  parseJSON =
    Aeson.withText "VehicleId" $
      \vehicleUrl ->
        case Url.getId vehicleUrl of
          Right intId -> pure . VehicleId $ intId
          Left e -> fail e

instance ToJSON (VehicleId :: Type) where
  toJSON :: VehicleId -> Value
  toJSON = String . buildVehicleUrl

instance FromJSON (StarshipId :: Type) where
  parseJSON :: Value -> Parser StarshipId
  parseJSON =
    Aeson.withText "StarshipId" $
      \starshipUrl ->
        case Url.getId starshipUrl of
          Right intId -> pure . StarshipId $ intId
          Left e -> fail e

instance ToJSON (StarshipId :: Type) where
  toJSON :: StarshipId -> Value
  toJSON = String . buildStarshipUrl

instance FromJSON (PersonId :: Type) where
  -- Gonna parse it from `url` which is why it's from text
  parseJSON :: Value -> Parser PersonId
  parseJSON =
    Aeson.withText "PersonId" $
      \personUrl ->
        case Url.getId personUrl of
          Right intId -> pure . PersonId $ intId
          Left e -> fail e

instance ToJSON (PersonId :: Type) where
  toJSON :: PersonId -> Value
  toJSON = String . buildPersonUrl

--------------------------------------------------------------------------------
-- Unwrap newtypes

unFilmId :: FilmId -> Int
unFilmId (FilmId filmId) = filmId

unHomeworldId :: HomeworldId -> Int
unHomeworldId (HomeworldId homeworldId) = homeworldId

unSpeciesId :: SpeciesId -> Int
unSpeciesId (SpeciesId speciesId) = speciesId

unVehicleId :: VehicleId -> Int
unVehicleId (VehicleId vehicleId) = vehicleId

unStarshipId :: StarshipId -> Int
unStarshipId (StarshipId starshipId) = starshipId

unPersonId :: PersonId -> Int
unPersonId (PersonId pId) = pId

------------------------------------------------------------------------------
-- Other functions
-- TODO(sekun): How do I guarantee that this is a URL? Text can be anything.

buildFilmUrl :: FilmId -> Text
buildFilmUrl filmId =
  mconcat [Url.resourceUrl Film, Text.Show.showt . unFilmId $ filmId, "/"]

buildPlanetUrl :: HomeworldId -> Text
buildPlanetUrl homeworldId =
  mconcat
    [ Url.resourceUrl Planet
    , Text.Show.showt . unHomeworldId $ homeworldId
    , "/"
    ]

buildSpeciesUrl :: SpeciesId -> Text
buildSpeciesUrl speciesId =
  mconcat
    [ Url.resourceUrl Species
    , Text.Show.showt . unSpeciesId $ speciesId
    , "/"
    ]

buildVehicleUrl :: VehicleId -> Text
buildVehicleUrl vehicleId =
  mconcat
    [ Url.resourceUrl Vehicle
    , Text.Show.showt . unVehicleId $ vehicleId
    , "/"
    ]

buildStarshipUrl :: StarshipId -> Text
buildStarshipUrl starshipId =
  mconcat
    [ Url.resourceUrl Starship
    , Text.Show.showt . unStarshipId $ starshipId
    , "/"
    ]

buildPersonUrl :: PersonId -> Text
buildPersonUrl personId =
  mconcat
    [ Url.resourceUrl People
    , Text.Show.showt . unPersonId $ personId
    , "/"
    ]
