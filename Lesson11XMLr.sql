create database MusicXML

use MusicXML


CREATE TABLE tArtist (
      artistId INT NOT NULL PRIMARY KEY
    , name VARCHAR(100) NOT NULL
    , xmlData XML NOT NULL
);

INSERT INTO dbo.tArtist (artistId, name, xmlData) VALUES
(1, 'Radiohead',
'<albums>
    <album title="The King of Limbs">
        <labels>
            <label>Self-released</label>
        </labels>
        <song title="Bloom" length="5:15"/>
        <song title="Morning Mr Magpie" length="4:41"/>
        <song title="Little by Little" length="4:27"/>
        <song title="Feral" length="3:13"/>
        <song title="Lotus Flower" length="5:01"/>
        <song title="Codex" length="4:47"/>
        <song title="Give Up the Ghost" length="4:50"/>
        <song title="Separator" length="5:20"/>
        <description link="http://en.wikipedia.org/wiki/The_King_of_Limbs">
        The King of Limbs is the eighth studio album by English rock band Radiohead,
        produced by Nigel Godrich. It was self-released on 18 February 2011 as a 
        download in MP3 and WAV formats, followed by physical CD and 12" vinyl 
        releases on 28 March, a wider digital release via AWAL, and a special 
        "newspaper" edition on 9 May 2011. The physical editions were released 
        through the band''s Ticker Tape imprint on XL in the United Kingdom, 
        TBD in the United States, and Hostess Entertainment in Japan.
        </description>
    </album>
    <album title="OK Computer">
        <labels>
            <label>Parlophone</label>
            <label>Capitol</label>
        </labels>
        <song title="Airbag" length="4:44"/>
        <song title="Paranoid Android" length="6:23"/>
        <song title="Subterranean Homesick Alien" length="4:27"/>
        <song title="Exit Music (For a Film)" length="4:24"/>
        <song title="Let Down" length="4:59"/>
        <song title="Karma Police" length="4:21"/>
        <song title="Fitter Happier" length="1:57"/>
        <song title="Electioneering" length="3:50"/>
        <song title="Climbing Up the Walls" length="4:45"/>
        <song title="No Surprises" length="3:48"/>
        <song title="Lucky" length="4:19"/>
        <song title="The Tourist" length="5:24"/>
        <description link="http://en.wikipedia.org/wiki/OK_Computer">
        OK Computer is the third studio album by the English alternative rock band 
        Radiohead, released on 16 June 1997 on Parlophone in the United Kingdom and 
        1 July 1997 by Capitol Records in the United States. It marks a deliberate 
        attempt by the band to move away from the introspective guitar-oriented 
        sound of their previous album The Bends. Its layered sound and wide range 
        of influences set it apart from many of the Britpop and alternative rock 
        bands popular at the time and laid the groundwork for Radiohead''s later, 
        more experimental work.
        </description>
    </album>
</albums>'),
(2, 'Guns N'' Roses',
'<albums>
    <album title="Use Your Illusion I">
        <labels>
            <label>Geffen Records</label>
        </labels>
        <song title="Right Next Door to Hell" length="3:02"/>
        <song title="Dust N'' Bones" length="4:58"/>
        <song title="Live and Let Die (Paul McCartney and Wings cover)" 
        length="3:04"/>
        <song title="Don''t Cry (original version)" length="4:44"/>
        <song title="Perfect Crime" length="2:24"/>
        <song title="You Ain''t the First" length="2:36"/>
        <song title="Bad Obsession" length="5:28"/>
        <song title="Back Off Bitch" length="5:04"/>
        <song title="Double Talkin'' Jive" length="3:24"/>
        <song title="November Rain" length="8:57"/>
        <song title="The Garden (featuring Alice Cooper and Shannon Hoon)" 
        length="5:22"/>
        <song title="Garden of Eden" length="2:42"/>
        <song title="Don''t Damn Me" length="5:19"/>
        <song title="Bad Apples" length="4:28"/>
        <song title="Dead Horse" length="4:18"/>
        <song title="Coma" length="10:13"/>
        <description link="http://ru.wikipedia.org/wiki/Use_Your_Illusion_I">
        Use Your Illusion I is the third studio album by GnR. It was the first of two 
        albums released in conjunction with the Use Your Illusion Tour, the other 
        being Use Your Illusion II. The two are thus sometimes considered a double album. 
        In fact, in the original vinyl releases, both Use Your Illusion albums are 
        double albums. Material for all two/four discs (depending on the medium) was 
        recorded at the same time and there was some discussion of releasing a 
        ''quadruple album''. The album debuted at No. 2 on the Billboard charts, selling 
        685,000 copies in its first week, behind Use Your Illusion II''s first week sales
        of 770,000. Use Your Illusion I has sold 5,502,000 units in the U.S. as of 2010, 
        according to Nielsen SoundScan. It was nominated for a Grammy Award in 1992.
        </description>
    </album>
    <album title="Use Your Illusion II">
        <labels>
            <label>Geffen Records</label>
        </labels>
        <song title="Civil War" length="7:42"/>
        <song title="14 Years" length="4:21"/>
        <song title="Yesterdays" length="3:16"/>
        <song title="Knockin'' on Heaven''s Door (Bob Dylan cover)" length="5:36"/>
        <song title="Get in the Ring" length="5:41"/>
        <song title="Shotgun Blues" length="3:23"/>
        <song title="Breakdown" length="7:05"/>
        <song title="Pretty Tied Up" length="4:48"/>
        <song title="Locomotive (Complicity)" length="8:42"/>
        <song title="So Fine" length="4:06"/>
        <song title="Estranged" length="9:24"/>
        <song title="You Could Be Mine" length="5:43"/>
        <song title="Don''t Cry (Alternate lyrics)" length="4:44"/>
        <song title="My World" length="1:24"/>
        <description link="http://ru.wikipedia.org/wiki/Use_Your_Illusion_II">
        Use Your Illusion II is the fourth studio album by GnR. It was one of two albums 
        released in conjunction with the Use Your Illusion Tour, and as a result the two 
        albums are sometimes considered a double album. Bolstered by lead single ''You 
        Could Be Mine'', Use Your Illusion II was the slightly more popular of the two 
        albums, selling 770,000 copies its first week and debuting at No. 1 on the U.S. 
        charts, ahead of Use Your Illusion I''s first week sales of 685,000.
        </description>
    </album>
</albums>');

SELECT name, xmlData.query('/albums/album[2]/labels/label[1]') AS SecondAlbumLabel
FROM tArtist;
SELECT name, xmlData.query('/albums/album[2]/labels/label[2]') AS SecondAlbumLabel
FROM tArtist;

SELECT name, 
xmlData.query ('/albums/album[description[contains(., "record")]]') AS ContainsRecord
FROM tArtist;
--не чутливо до регістру
SELECT name, 
xmlData.query ('/albums/album[description[contains(lower-case(.), "record")]]') 
AS ContainsRecord
FROM dbo.tArtist;

---помилка
SELECT name, 
xmlData.value('/albums/album[2]/labels/label[1]/text()', 'varchar(100)') AS SecondAlbumLabel
FROM dbo.tArtist;
SELECT name, 
xmlData.value('/albums[1]/album[2]/labels[1]/label[1]/text()[1]', 'varchar(100)') AS SecondAlbumLabel
FROM dbo.tArtist;
SELECT name, 
xmlData.value ('(/albums/album[2]/labels/label/text())[1]', 'varchar(100)') AS SecondAlbumLabel
FROM dbo.tArtist;

SELECT name
    , xmlData.value('/albums[1]/album[1]/@title', 'varchar(100)') AS FirstAlbum
    , xmlData.value('/albums[1]/album[1]/song[1]/@title', 'varchar(100)') AS FirstSongTitle
    , xmlData.value('/albums[1]/album[1]/song[1]/@length', 'time(0)') AS FirstSongLength
FROM dbo.tArtist;

SELECT name, xmlData.exist('/albums[1]/album/song[@title="Garden of Eden"]') AS SongExists
FROM dbo.tArtist;

use BookShopPublisher

create table XMLBook
(bookname xml )

declare @x xml; 
5
