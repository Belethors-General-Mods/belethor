defmodule Database.Repo.Migrations.CreateDatabase do
  alias Database.Repo
  alias Database.Schema.ModTag
  use Ecto.Migration

  def change do
    create table(:mod_image) do
      add(:data, :binary)
      add(:url, :string)
    end

    create table(:mod_tag) do
      add(:name, :string, null: false)
      add(:desc, :text)
    end

    create table(:mod) do
      add(:name, :string, null: false)
      add(:desc, :text, null: false)
      add(:published, :boolean, null: false)
      add(:oldrim, :map)
      add(:sse, :map)
      add(:images, references(:mod_image))
    end

    create table(:mods_tags) do
      add(:mod_tag_id, references(:mod_tag), null: false)
      add(:mod_id, references(:mod), null: false)
    end

    create table(:mods_images) do
      add(:mod_image_id, references(:mod_image), null: false)
      add(:mod_id, references(:mod), null: false)
    end

    create table(:mod_dependencies) do
      add(:requires_id, references(:mod_tag), null: false)
      add(:required_by_id, references(:mod), null: false)
    end

    create(unique_index(:mod, [:name]))
    create(unique_index(:mod_tag, [:name]))
    create(unique_index(:mod_image, [:data]))
    create(unique_index(:mod_image, [:url]))
    create(unique_index(:mods_tags, [:mod_id, :mod_tag_id]))
    create(unique_index(:mod_dependencies, [:requires_id, :required_by_id]))

    flush()

    # import our tags
    Repo.insert_all(
      ModTag,
      [
        %{name: "Animation"},
        %{name: "Animation.Actions"},
        %{name: "Animation.Combat"},
        %{name: "Animation.Combat.Melee"},
        %{name: "Animation.Combat.Ranged"},
        %{name: "Animation.Idle"},
        %{name: "Animation.Magic"},
        %{name: "Animation.Movement"},
        %{name: "Animation.Movement.Sneak"},
        %{name: "Audio"},
        %{name: "Audio.Ambient"},
        %{name: "Audio.Music"},
        %{name: "Audio.Overhaul"},
        %{name: "Audio.SFX"},
        %{name: "Audio.Voice"},
        %{name: "Characters"},
        %{name: "Characters.Attributes"},
        %{name: "Characters.Body"},
        %{name: "Characters.Body.Face"},
        %{name: "Characters.Body.Hair"},
        %{name: "Characters.Classes"},
        %{name: "Characters.Clothing"},
        %{name: "Characters.Clothing.Female"},
        %{name: "Characters.Clothing.Jewelry"},
        %{name: "Characters.Clothing.Male"},
        %{name: "Characters.NPC"},
        %{name: "Characters.NPC.Followers"},
        %{name: "Characters.NPC.Trainers"},
        %{name: "Characters.NPC.Vendors"},
        %{name: "Characters.Poses"},
        %{name: "Characters.Races"},
        %{name: "Combat"},
        %{name: "Combat.Melee"},
        %{name: "Combat.Ranged"},
        %{name: "Combat.Magic"},
        %{name: "Combat.Tweaks"},
        %{name: "Crafting"},
        %{name: "Crafting.Alchemy"},
        %{name: "Crafting.Alchemy.Ingridients"},
        %{name: "Crafting.Smithery"},
        %{name: "Crafting.Smithery.Ingridients"},
        %{name: "Crafting.Smithery.Ingridients.Ingots"},
        %{name: "Crafting.Smithery.Ingridients.Leather"},
        %{name: "Creatures"},
        %{name: "Creatures.Domesticated"},
        %{name: "Creatures.Mounts"},
        %{name: "Creatures.Wild"},
        %{name: "Faction"},
        %{name: "Faction.College_of_Winterhold"},
        %{name: "Faction.Companions"},
        %{name: "Faction.Dark_Brotherhood"},
        %{name: "Faction.Dawnguard"},
        %{name: "Faction.Thieves_Guild"},
        %{name: "Faction.Volkihar"},
        %{name: "Gameplay"},
        %{name: "Gameplay.Balanced"},
        %{name: "Gameplay.Effects_and_Changes"},
        %{name: "Gameplay.Immersion"},
        %{name: "Gameplay.Immersion.Lore-Friendly"},
        %{name: "Gameplay.Immersion.Realism"},
        %{name: "Gameplay.Leveled_Lists"},
        %{name: "Gameplay.Leveling"},
        %{name: "Gameplay.New_Content"},
        %{name: "Gameplay.Overhaul"},
        %{name: "Gameplay.Save_Games"},
        %{name: "Gameplay.Scripted"},
        %{name: "Gameplay.User_Interface"},
        %{name: "Gameplay.Cheats_and_God_items"},
        %{name: "Gameplay.Collectables_Treasure_Hunts"},
        %{name: "Graphics"},
        %{name: "Graphics.ENB_Preset"},
        %{name: "Graphics.Lighting"},
        %{name: "Graphics.Models"},
        %{name: "Graphics.Overhaul"},
        %{name: "Graphics.Textures"},
        %{name: "Items"},
        %{name: "Items.Armour"},
        %{name: "Items.Armour.Female"},
        %{name: "Items.Armour.Male"},
        %{name: "Items.Armour.Shields"},
        %{name: "Items.Books"},
        %{name: "Items.Books.Scrolls"},
        %{name: "Items.Books.Skill"},
        %{name: "Items.Books.Spell"},
        %{name: "Items.Weapons"},
        %{name: "Items.Weapons.One-handed"},
        %{name: "Items.Weapons.Ranged"},
        %{name: "Items.Weapons.Two-handed"},
        %{name: "Items.Magic"},
        %{name: "Items.Magic.Staffs"},
        %{name: "Language"},
        %{name: "Language.Czech"},
        %{name: "Language.English"},
        %{name: "Language.French"},
        %{name: "Language.German"},
        %{name: "Language.Hungarian"},
        %{name: "Language.Italian"},
        %{name: "Language.Japanese"},
        %{name: "Language.Other"},
        %{name: "Language.Polish"},
        %{name: "Language.Russian"},
        %{name: "Language.Spanish"},
        %{name: "Language.Translation"},
        %{name: "Magic"},
        %{name: "Magic.Birthsigns"},
        %{name: "Magic.Enchantments"},
        %{name: "Magic.Shouts"},
        %{name: "Magic.Spells"},
        %{name: "Magic.StandingStones"},
        %{name: "MI.Compilation"},
        %{name: "MI.Dirty"},
        %{name: "MI.ENB"},
        %{name: "MI.ENB.DLL"},
        %{name: "MI.Official"},
        %{name: "MI.Replacer"},
        %{name: "MI.Resources"},
        %{name: "Miscellaneous"},
        %{name: "Miscellaneous.Anime"},
        %{name: "Miscellaneous.Humor"},
        %{name: "MI.SKSE"},
        %{name: "MI.SKSE.DLL"},
        %{name: "MI.Tutorials"},
        %{name: "MI.Unrealistic"},
        %{name: "MI.Utilities"},
        %{name: "MI.Vanilla"},
        %{name: "MI.Videos_and_Trailers"},
        %{name: "Not_Safe_For_Work"},
        %{name: "Not_Safe_For_Work.Extreme_violence/gore"},
        %{name: "Not_Safe_For_Work.Nudity"},
        %{name: "Not_Safe_For_Work.Sexy/Skimpy"},
        %{name: "Patches"},
        %{name: "Patches.Bug_Fixes"},
        %{name: "Patches.Performance"},
        %{name: "Skills"},
        %{name: "Skills.Magic"},
        %{name: "Skills.Stealth"},
        %{name: "Skills.Warrior"},
        %{name: "Total_Conversions"},
        %{name: "Total_Conversions.Enderal"},
        %{name: "World"},
        %{name: "World.Buildings"},
        %{name: "World.Buildings.Castles_Palaces_Mansions_Estates"},
        %{name: "World.Buildings.Forts_Ruins_Abandoned_Structures"},
        %{name: "World.Buildings.Mercantiles_(shops_stores_inns_taverns)"},
        %{name: "World.Buildings.Player_Homes"},
        %{name: "World.Cities_Towns_Villages"},
        %{name: "World.Environment"},
        %{name: "World.Environment.Foliage"},
        %{name: "World.Environment.Overhaul"},
        %{name: "World.Landscape"},
        %{name: "World.Locations"},
        %{name: "World.Locations.Dungeons"},
        %{name: "World.Objects"},
        %{name: "World.Quests"},
        %{name: "World.Solstheim"}
      ],
      []
    )
  end
end
