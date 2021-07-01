USE [master]
GO
/****** Object:  Database [Test1]    Script Date: 01.07.2021 9:38:57 ******/
CREATE DATABASE [Test1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Test1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Test1.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Test1_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Test1_log.ldf' , SIZE = 1280KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Test1] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Test1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Test1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Test1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Test1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Test1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Test1] SET ARITHABORT OFF 
GO
ALTER DATABASE [Test1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Test1] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Test1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Test1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Test1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Test1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Test1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Test1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Test1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Test1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Test1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Test1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Test1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Test1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Test1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Test1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Test1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Test1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Test1] SET RECOVERY FULL 
GO
ALTER DATABASE [Test1] SET  MULTI_USER 
GO
ALTER DATABASE [Test1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Test1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Test1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Test1] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Test1]
GO
/****** Object:  StoredProcedure [dbo].[BazaMSK_Select]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[BazaMSK_Select]

as 
SET NOCOUNT ON
SELECT [Tovar]+' '+Cast([Count] as varchar) as Tovar
  FROM [dbo].[BazaMSK]





SELECT [Tovar]
      ,[Count]
      ,[SaleID]
      ,[Data]
      ,[IdProiz]
  FROM [dbo].[BazaMSK]




GO
/****** Object:  StoredProcedure [dbo].[BazaMskFindProiz]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[BazaMskFindProiz]
(
@Tovar nvarchar(255)
)
as
SET NOCOUNT ON
/*
DECLARE @Tovar nvarchar(255)
Select @Tovar = 'Мясо'
*/

Select Proiz
  from BazaMSK join
       Proiz On BazaMSK.IdProiz = Proiz.IDProiz
 Where BazaMSK.Tovar = @Tovar
         
GO
/****** Object:  StoredProcedure [dbo].[BazaMSKInsert]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[BazaMSKInsert] 
(
@Tovar nvarchar(255),
@Count int,
@Data datetime,
@idProiz int
)
as
SET NOCOUNT ON


DECLARE @SaleId int
Select @SaleId = (Select Max(SaleId) from BazaMSK) + 1

If (Select Count(*) from BazaMSK Where Tovar = @Tovar) = 0 
  begin

  INSERT INTO [dbo].[BazaMSK]
           ([Tovar]
           ,[SaleID]
           ,[Count]
           ,[Data]
		   ,[IdProiz])
     VALUES
           (@Tovar
           ,@SaleID
           ,@Count
           ,@Data
		   ,@IdProiz)
END
ELSE BEGIN
   Update BazaMSK Set [Count] = [Count] + @Count, IdProiz = @idProiz WHERE Tovar = @Tovar
END
GO
/****** Object:  StoredProcedure [dbo].[Proiz_Select]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Proiz_Select]

as 
SET NOCOUNT ON
SELECT [Proiz]+' '+Cast([IDProiz] as varchar) as proiz
  FROM [dbo].[Proiz]
  Where Visible = 1




GO
/****** Object:  Table [dbo].[BazaMSK]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BazaMSK](
	[Tovar] [nvarchar](255) NOT NULL,
	[Count] [int] NOT NULL,
	[SaleID] [int] NOT NULL,
	[Data] [datetime] NOT NULL,
	[IdProiz] [int] NULL,
 CONSTRAINT [PK_BazaMSK_1] PRIMARY KEY CLUSTERED 
(
	[Tovar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Pokupatel]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pokupatel](
	[PokupkaID] [int] IDENTITY(1,1) NOT NULL,
	[Tovar] [nvarchar](255) NOT NULL,
	[Count] [int] NULL,
	[Data] [datetime] NULL,
 CONSTRAINT [PK_Pokupatel] PRIMARY KEY CLUSTERED 
(
	[Tovar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Proiz]    Script Date: 01.07.2021 9:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proiz](
	[Proiz] [nvarchar](255) NOT NULL,
	[IDProiz] [int] IDENTITY(1,1) NOT NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_PrID] PRIMARY KEY CLUSTERED 
(
	[IDProiz] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[BazaMSK] ADD  CONSTRAINT [DF_BazaMSK_SaleID]  DEFAULT ((1)) FOR [SaleID]
GO
ALTER TABLE [dbo].[Proiz] ADD  CONSTRAINT [DF_PrID_Visible]  DEFAULT ((1)) FOR [Visible]
GO
ALTER TABLE [dbo].[BazaMSK]  WITH CHECK ADD  CONSTRAINT [FK_BazaMSK_PrID] FOREIGN KEY([IdProiz])
REFERENCES [dbo].[Proiz] ([IDProiz])
ON UPDATE SET NULL
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[BazaMSK] CHECK CONSTRAINT [FK_BazaMSK_PrID]
GO
USE [master]
GO
ALTER DATABASE [Test1] SET  READ_WRITE 
GO
