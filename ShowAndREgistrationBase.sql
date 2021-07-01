USE [master]
GO
/****** Object:  Database [RegWind]    Script Date: 01.07.2021 11:51:39 ******/
CREATE DATABASE [RegWind]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RegWind', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\RegWind.mdf' , SIZE = 11264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RegWind_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\RegWind_log.ldf' , SIZE = 11200KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [RegWind] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RegWind].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RegWind] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RegWind] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RegWind] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RegWind] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RegWind] SET ARITHABORT OFF 
GO
ALTER DATABASE [RegWind] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RegWind] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [RegWind] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RegWind] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RegWind] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RegWind] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RegWind] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RegWind] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RegWind] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RegWind] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RegWind] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RegWind] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RegWind] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RegWind] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RegWind] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RegWind] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RegWind] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RegWind] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RegWind] SET RECOVERY FULL 
GO
ALTER DATABASE [RegWind] SET  MULTI_USER 
GO
ALTER DATABASE [RegWind] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RegWind] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RegWind] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RegWind] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [RegWind]
GO
/****** Object:  StoredProcedure [dbo].[ShowImagesInsert]    Script Date: 01.07.2021 11:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShowImagesInsert] 
( 
	@Url varchar(255), 
	@Name varchar(255),
	@Time datetime,
	@Comment varchar(255),
	@Img VARBINARY(MAX)

)
as
SET NOCOUNT ON

INSERT INTO [dbo].[ShowImageTablet]
		([Url]
		,[Name]
		,[Time]
		,[Comment]
		,[Img])
	VALUES
		(@Url, 
		@Name,
		@Time,
		@Comment,
		@Img
		)


GO
/****** Object:  StoredProcedure [dbo].[UsersCheckRegister]    Script Date: 01.07.2021 11:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[UsersCheckRegister] 
(
@phoneNum int,
@passW1 char(50),
@passW2 char(50)
)
as
SET NOCOUNT ON


If (Select Count(*) from UsersTabl Where phoneNum = @phoneNum) = 0 
  begin
  If (@passW1 = @passW2)
		select 1 as ToReturn
END
else 
	select 0 as ToReturn

GO
/****** Object:  StoredProcedure [dbo].[UsersRegister]    Script Date: 01.07.2021 11:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UsersRegister] 
(
@phoneNum int,
@userName1 nvarchar(255),
@userName2 nvarchar(255),
@passW1 char(50),
@passW2 char(50),
@BDay datetime,
@regDate datetime
)
as
SET NOCOUNT ON


If (Select Count(*) from UsersTabl Where phoneNum = @phoneNum) = 0 
  begin
  If (@passW1 = @passW2)
	  INSERT INTO [dbo].[UsersTabl]
			   ([phoneNum]
			   ,[userName1]
			   ,[userName2]
			   ,[passW1] 
			   ,[passW2] 
			   ,[BDay]
			   ,[regDate])
		 VALUES
			   (@phoneNum
			   ,@userName1
			   ,@userName2
			   ,@passW1
			   ,@passW2
			   ,@BDay
			   ,@regDate)
		select 0 as ToReturn
END
else 
	select 1 as ToReturn

GO
/****** Object:  Table [dbo].[ShowImageTablet]    Script Date: 01.07.2021 11:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShowImageTablet](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Url] [varchar](255) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Time] [datetime] NOT NULL,
	[Comment] [varchar](255) NULL,
	[Img] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UsersTabl]    Script Date: 01.07.2021 11:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UsersTabl](
	[userID] [int] IDENTITY(1,1) NOT NULL,
	[phoneNum] [int] NOT NULL,
	[userName1] [nvarchar](255) NOT NULL,
	[userName2] [nvarchar](255) NOT NULL,
	[passW1] [char](50) NOT NULL,
	[passW2] [char](50) NOT NULL,
	[BDay] [date] NULL,
	[regDate] [datetime] NULL,
 CONSTRAINT [PK_UsersTabl] PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UsersTabl]    Script Date: 01.07.2021 11:51:39 ******/
CREATE NONCLUSTERED INDEX [IX_UsersTabl] ON [dbo].[UsersTabl]
(
	[phoneNum] ASC,
	[passW1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [RegWind] SET  READ_WRITE 
GO
