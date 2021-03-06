USE [OlaGlasses]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Rating_Stats]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Get_Rating_Stats]
(@Productid int,
@type char(2)
)
RETURNS int 
BEGIN  
	Declare @Result as int
		if(@type='TR')
			Begin
				select  @Result =count(*) from tblReviews where GlassID = @Productid
			End
		else if (@type = 'AR')
			Begin
				Declare @Ratingsum as int=0
				Declare @Ratingcount as int=0
				Declare @AverageRating as int = 0 

				 select @Ratingsum =Sum(Rating) from tblReviews where  GlassID = @Productid
				 select @Ratingcount =count(Rating) from tblReviews where  GlassID = @Productid
				 set @Ratingcount = @Ratingcount * 5
				 set @AverageRating =   (@Ratingsum *5)/@Ratingcount;

				 set @Result = @AverageRating
			End
	 Return  (select @Result)
END
GO
/****** Object:  Table [dbo].[ActivationCode]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivationCode](
	[UID] [int] NOT NULL,
	[Code] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ForgetPassword]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForgetPassword](
	[UID] [int] NOT NULL,
	[Code] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblcart]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblcart](
	[Cartid] [int] IDENTITY(1,1) NOT NULL,
	[GlassID] [int] NOT NULL,
	[Variationid] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[LensType] [varchar](50) NOT NULL,
	[VisionType] [varchar](50) NOT NULL,
	[UVProtection] [varchar](50) NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[Userid] [int] NOT NULL,
	[r_sph] [varchar](50) NULL,
	[r_cyl] [varchar](50) NULL,
	[r_axis] [varchar](50) NULL,
	[r_add] [varchar](50) NULL,
	[l_sph] [varchar](50) NULL,
	[l_cyl] [varchar](50) NULL,
	[l_axis] [varchar](50) NULL,
	[l_add] [varchar](50) NULL,
	[PD] [float] NULL,
	[PDImage] [varchar](500) NULL,
	[PrescriptionImage] [varchar](500) NULL,
	[Title] [varchar](500) NULL,
	[shape] [varchar](50) NULL,
	[Colour] [varchar](50) NULL,
	[Price] [float] NULL,
	[ProductImagePath] [varchar](500) NULL,
	[Size] [varchar](50) NULL,
	[Productcategory] [varchar](50) NULL,
	[TaxAmount] [float] NULL,
	[Discount] [float] NULL,
	[Shippingamount] [float] NULL,
	[GranTotal] [float] NULL,
	[Fname] [varchar](50) NULL,
	[Lname] [varchar](50) NULL,
	[prescription] [varchar](50) NULL,
	[prescriptionDate] [date] NULL,
	[Extracharges] [int] NULL,
	[CouponID] [int] NOT NULL,
	[CouponCode] [nchar](100) NULL,
	[Discountamount] [float] NULL,
	[Rightpd] [float] NULL,
	[Segmentheight] [nvarchar](300) NULL,
	[Dualpd] [int] NULL,
	[Prescriptionid] [int] NULL,
 CONSTRAINT [PK_tblcart] PRIMARY KEY CLUSTERED 
(
	[Cartid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblColors]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblColors](
	[ColorID] [int] IDENTITY(1,1) NOT NULL,
	[hexacode] [nvarchar](255) NULL,
	[colorname] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblColors] PRIMARY KEY CLUSTERED 
(
	[ColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCoupon]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCoupon](
	[CouponID] [int] IDENTITY(1,1) NOT NULL,
	[CouponCode] [nchar](100) NULL,
	[DiscountType] [varchar](50) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Description] [varchar](500) NULL,
	[CouponStatus] [varchar](50) NULL,
	[CouponLink] [varchar](100) NULL,
	[CouponColor] [varchar](50) NULL,
	[TimesUsed] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Text] [varchar](500) NULL,
 CONSTRAINT [PK_tblCoupon] PRIMARY KEY CLUSTERED 
(
	[CouponID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFavourite]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFavourite](
	[FavouriteID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[UserID] [int] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_tblFavourite] PRIMARY KEY CLUSTERED 
(
	[FavouriteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblglassPicture]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblglassPicture](
	[PictureID] [int] IDENTITY(1,1) NOT NULL,
	[glassID] [int] NULL,
	[ImagePath] [varchar](100) NULL,
 CONSTRAINT [PK_tblglassPicture] PRIMARY KEY CLUSTERED 
(
	[PictureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrder]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrder](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[UserEmail] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[IsPaid] [int] NULL,
	[Total] [numeric](18, 2) NULL,
	[Vision] [varchar](50) NULL,
	[LensType] [varchar](50) NULL,
	[OrderComments] [varchar](1000) NULL,
	[OrderDate] [date] NULL,
	[UserAddress] [varchar](500) NULL,
	[BFname] [varchar](100) NULL,
	[BLname] [varchar](100) NULL,
	[BAddress] [varchar](1000) NULL,
	[Bcity] [varchar](100) NULL,
	[BState] [varchar](100) NULL,
	[BPostalCode] [varchar](100) NULL,
	[BCountry] [varchar](100) NULL,
	[BPhone] [varchar](100) NULL,
	[BEmail] [varchar](100) NULL,
	[SFname] [varchar](100) NULL,
	[SLname] [varchar](100) NULL,
	[SAddress] [varchar](1000) NULL,
	[Scity] [varchar](100) NULL,
	[SState] [varchar](100) NULL,
	[SPostalCode] [varchar](100) NULL,
	[SCountry] [varchar](100) NULL,
	[SPhone] [varchar](100) NULL,
	[SEmail] [varchar](100) NULL,
	[CouponID] [int] NOT NULL,
	[CouponCode] [nchar](100) NULL,
	[Discountamount] [float] NULL,
	[Discountpercentage] [float] NULL,
 CONSTRAINT [PK_tblOrder] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrderDetails]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrderDetails](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[ProductID] [int] NULL,
	[Productname] [varchar](50) NULL,
	[ProductPrice] [varchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[Vision] [varchar](50) NULL,
	[LensType] [varchar](50) NULL,
	[UV_Protection] [varchar](50) NULL,
	[Total] [varchar](50) NULL,
	[ProductVariation] [int] NULL,
	[quantity] [int] NULL,
	[TaxAmount] [float] NULL,
	[Discount] [float] NULL,
	[FrameColor] [varchar](50) NULL,
	[ProductImage] [varchar](500) NULL,
	[ShippingAmount] [float] NULL,
	[Subtotal] [float] NULL,
 CONSTRAINT [PK_tblOrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrderPrescription]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrderPrescription](
	[PrescriptionID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[OrderID] [int] NULL,
	[r_sph] [varchar](50) NULL,
	[r_cyl] [varchar](50) NULL,
	[r_axis] [varchar](50) NULL,
	[r_add] [varchar](50) NULL,
	[l_sph] [varchar](50) NULL,
	[l_cyl] [varchar](50) NULL,
	[l_axis] [varchar](50) NULL,
	[l_add] [varchar](50) NULL,
	[lensType] [varchar](50) NULL,
	[quantity] [int] NULL,
	[Fname] [varchar](50) NULL,
	[Lname] [varchar](50) NULL,
	[prescription] [varchar](300) NULL,
	[prescriptionDate] [date] NULL,
	[PD] [float] NULL,
	[UserID] [int] NULL,
	[PDImage] [varchar](500) NULL,
	[PrescriptionImage] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[Rightpd] [float] NULL,
	[Segmentheight] [nvarchar](300) NULL,
	[Dualpd] [int] NULL,
 CONSTRAINT [PK_tblOrderPrescription] PRIMARY KEY CLUSTERED 
(
	[PrescriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProduct]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProduct](
	[GlassID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](500) NULL,
	[shape] [varchar](50) NULL,
	[Colour] [varchar](50) NULL,
	[Material] [varchar](50) NULL,
	[Brand] [varchar](50) NULL,
	[Gender] [varchar](50) NULL,
	[AdditionalInfo] [varchar](500) NULL,
	[AvailableSize] [varchar](50) NULL,
	[Price] [float] NULL,
	[Cost] [float] NULL,
	[CreatedDate] [datetime] NULL,
	[Manufacturer] [varchar](100) NULL,
	[Model] [varchar](50) NULL,
	[OrignalCode] [varchar](50) NULL,
	[Mgf_Code] [varchar](50) NULL,
	[Rim] [varchar](50) NULL,
	[Sticker] [varchar](50) NULL,
	[Feature] [varchar](50) NULL,
	[ProductCategory] [varchar](50) NULL,
	[ReleatedTo] [int] NULL,
	[Clicks] [int] NULL,
	[SellinClinic] [varchar](50) NULL,
	[ImagePath] [varchar](500) NULL,
	[SKUNumber] [varchar](300) NULL,
 CONSTRAINT [PK_tblProduct] PRIMARY KEY CLUSTERED 
(
	[GlassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblpromotionoffer]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblpromotionoffer](
	[Promotionid] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](300) NOT NULL,
	[colorcode] [varchar](50) NOT NULL,
	[colorname] [varchar](50) NOT NULL,
	[isActive] [int] NOT NULL,
 CONSTRAINT [PK_tblpromotionoffer] PRIMARY KEY CLUSTERED 
(
	[Promotionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReviewLike]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReviewLike](
	[ReviewLikeID] [int] IDENTITY(1,1) NOT NULL,
	[ReviewID] [int] NULL,
	[UserID] [int] NULL,
	[Productid] [int] NULL,
 CONSTRAINT [PK_tblReviewLike] PRIMARY KEY CLUSTERED 
(
	[ReviewLikeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReviews]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReviews](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[GlassID] [int] NULL,
	[Rating] [int] NULL,
	[Review] [varchar](1000) NULL,
	[CreatedDate] [datetime] NULL,
	[ReviewImage] [varchar](100) NULL,
	[UserName] [nvarchar](100) NULL,
	[UserImage] [varchar](100) NULL,
 CONSTRAINT [PK_tblReviews] PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSettings]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSettings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[clientId] [nvarchar](max) NULL,
	[clientSecret] [nvarchar](max) NULL,
	[AccountType] [varchar](100) NULL,
	[Email] [varchar](200) NULL,
	[Password] [nvarchar](200) NULL,
	[SMTP] [nvarchar](100) NULL,
	[Port] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[StripeID] [nvarchar](max) NULL,
	[ReceipentEmail] [varchar](200) NULL,
 CONSTRAINT [PK_tblSettings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSizes]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSizes](
	[SizeID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](50) NULL,
	[TypeValue] [varchar](50) NULL,
 CONSTRAINT [PK_tblSizes] PRIMARY KEY CLUSTERED 
(
	[SizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserEmail] [varchar](100) NULL,
	[UserPass] [varchar](100) NULL,
	[Address] [varchar](500) NULL,
	[Phone] [varchar](100) NULL,
	[Role] [varchar](100) NULL,
	[Firstname] [nvarchar](100) NULL,
	[Lastname] [nvarchar](100) NULL,
	[UserImage] [nvarchar](1000) NULL,
	[DateofBirth] [date] NULL,
	[Gender] [varchar](50) NULL,
	[UserStatus] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[FaxNumber] [nvarchar](200) NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserPrescription]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserPrescription](
	[PrescriptionID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[OrderID] [int] NULL,
	[r_sph] [varchar](50) NULL,
	[r_cyl] [varchar](50) NULL,
	[r_axis] [varchar](50) NULL,
	[r_add] [varchar](50) NULL,
	[l_sph] [varchar](50) NULL,
	[l_cyl] [varchar](50) NULL,
	[l_axis] [varchar](50) NULL,
	[l_add] [varchar](50) NULL,
	[lensType] [varchar](50) NULL,
	[quantity] [int] NULL,
	[Fname] [varchar](50) NULL,
	[Lname] [varchar](50) NULL,
	[prescription] [varchar](300) NULL,
	[prescriptionDate] [date] NULL,
	[PD] [float] NULL,
	[UserID] [int] NULL,
	[PDImage] [varchar](500) NULL,
	[PrescriptionImage] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[Rightpd] [float] NULL,
	[Segmentheight] [nvarchar](300) NULL,
	[Dualpd] [int] NULL,
 CONSTRAINT [PK_tblUserPrescription] PRIMARY KEY CLUSTERED 
(
	[PrescriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblVariation]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblVariation](
	[VariationID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[ColorCode] [varchar](50) NULL,
	[Color1] [varchar](50) NULL,
	[Color2] [varchar](50) NULL,
	[size] [varchar](50) NULL,
	[FrameAWidth] [float] NULL,
	[FrameBHeight] [float] NULL,
	[FrameED] [varchar](50) NULL,
	[FrameDBBridger] [varchar](50) NULL,
	[FrameTempleLegs] [varchar](50) NULL,
	[FrameTotalWidth] [varchar](50) NULL,
	[MinPDPositive] [varchar](50) NULL,
	[MinPDNeg] [varchar](50) NULL,
	[ImagePath] [varchar](500) NULL,
	[CreatedDate] [nchar](10) NULL,
	[SideViewImagePath] [varchar](500) NULL,
	[SKUNumber] [varchar](300) NULL,
 CONSTRAINT [PK_tblVariation] PRIMARY KEY CLUSTERED 
(
	[VariationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblvariationimages]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblvariationimages](
	[Variationimageid] [int] IDENTITY(1,1) NOT NULL,
	[ImagePath] [varchar](500) NOT NULL,
	[VariationID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
 CONSTRAINT [PK_tblvariationimages] PRIMARY KEY CLUSTERED 
(
	[Variationimageid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblcart] ON 
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2120, 9, 7, 1, N'Standard', N'Reading', N'on', 209, 2, N'+7.75', N'-0.50', N'33', N'4.50', N'+8.00', N'0.00', N'45', N'4.50', 48, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', N'Ola Optical', N'Rectangle', N'#665D1E', 150, N'/ProjectImages/Variations/Capture.png', N'Small', N'Eyeglass', 10.45, 0, NULL, 667.35, N'Hasan ', N'Bilal', N'Qadeerkhici963', CAST(N'2022-11-11' AS Date), 0, 0, NULL, 0, 55, N'Bifocal', 1, 21)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2122, 9, 7, 1, N'Standard', N'Reading', N'on', 209, 2, N'+7.50', N'-2.00', N'12', N'4.50', N'+4.25', N'-1.00', N'12', N'4.25', 44, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', N'Ola Optical', N'Rectangle', N'#665D1E', 150, N'/ProjectImages/Variations/Capture.png', N'Small', N'Eyeglass', NULL, NULL, NULL, 667.35, N'Syed', N'Yazdadn', N'Yazdad123', CAST(N'2022-04-08' AS Date), 0, 0, NULL, NULL, 0, N'Bifocal', 0, 0)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2123, 9, 7, 1, N'Standard', N'Reading', N'on', 209, 2, N'+7.50', N'-2.00', N'12', N'4.50', N'+4.25', N'-1.00', N'12', N'4.25', 44, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', N'Ola Optical', N'Rectangle', N'#665D1E', 150, N'/ProjectImages/Variations/Capture.png', N'Small', N'Eyeglass', NULL, NULL, NULL, 667.35, N'Syed', N'Yazdadn', N'Yazdad123', CAST(N'2022-04-08' AS Date), 0, 0, NULL, NULL, 0, N'Bifocal', 0, 22)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2142, 14, 0, 1, N'', N'', N'', 150, 1022, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'bilal', NULL, N'zz', 150, N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', N'No size', N'Accessory', NULL, NULL, 9, 166.5, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2154, 24, 0, 1, N'', N'', N'', 100, 1021, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Ola Accessory', NULL, N'zz', 100, N'/ProjectImages/AccessoryImage/additional-right-img_(1).png', N'No size', N'Accessory', 25, 0, 9, 534, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2155, 24, 0, 1, N'', N'', N'', 100, 1021, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Ola Accessory', NULL, N'zz', 100, N'/ProjectImages/AccessoryImage/additional-right-img_(1).png', N'No size', N'Accessory', 25, 0, 9, 534, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2156, 24, 0, 1, N'', N'', N'', 100, 1021, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Ola Accessory', NULL, N'zz', 100, N'/ProjectImages/AccessoryImage/additional-right-img_(1).png', N'No size', N'Accessory', 25, 0, 9, 534, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2157, 24, 0, 1, N'', N'', N'', 100, 1021, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Ola Accessory', NULL, N'zz', 100, N'/ProjectImages/AccessoryImage/additional-right-img_(1).png', N'No size', N'Accessory', 25, 0, 9, 534, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2158, 24, 0, 1, N'', N'', N'', 100, 1021, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Ola Accessory', NULL, N'zz', 100, N'/ProjectImages/AccessoryImage/additional-right-img_(1).png', N'No size', N'Accessory', 25, 0, 9, 534, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblcart] ([Cartid], [GlassID], [Variationid], [Quantity], [LensType], [VisionType], [UVProtection], [TotalAmount], [Userid], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [PD], [PDImage], [PrescriptionImage], [Title], [shape], [Colour], [Price], [ProductImagePath], [Size], [Productcategory], [TaxAmount], [Discount], [Shippingamount], [GranTotal], [Fname], [Lname], [prescription], [prescriptionDate], [Extracharges], [CouponID], [CouponCode], [Discountamount], [Rightpd], [Segmentheight], [Dualpd], [Prescriptionid]) VALUES (2174, 1, 0, 1, N'', N'', N'', 100, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'JinJIn Glass', NULL, N'#665D1E', 100, N'/ProjectImages/Variations/1.png', N'Small', N'Accessory', NULL, NULL, 9, 114, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblcart] OFF
GO
SET IDENTITY_INSERT [dbo].[tblColors] ON 
GO
INSERT [dbo].[tblColors] ([ColorID], [hexacode], [colorname]) VALUES (1, N'#000000', N'Black')
GO
INSERT [dbo].[tblColors] ([ColorID], [hexacode], [colorname]) VALUES (2, N'#665D1E', N'Antique')
GO
INSERT [dbo].[tblColors] ([ColorID], [hexacode], [colorname]) VALUES (3, N'#8C001A', N'Burgundy')
GO
INSERT [dbo].[tblColors] ([ColorID], [hexacode], [colorname]) VALUES (4, N'#009B95', N'Green')
GO
SET IDENTITY_INSERT [dbo].[tblColors] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCoupon] ON 
GO
INSERT [dbo].[tblCoupon] ([CouponID], [CouponCode], [DiscountType], [Discount], [Description], [CouponStatus], [CouponLink], [CouponColor], [TimesUsed], [CreatedDate], [CreatedBy], [Text]) VALUES (2, N'XYZ123abc                                                                                           ', NULL, CAST(10.00 AS Numeric(18, 2)), N'This is only for 10 Days', N'Active', N'https://localhost:44349/Coupons/Create', N'#000000', NULL, NULL, NULL, N'Free Coupons')
GO
INSERT [dbo].[tblCoupon] ([CouponID], [CouponCode], [DiscountType], [Discount], [Description], [CouponStatus], [CouponLink], [CouponColor], [TimesUsed], [CreatedDate], [CreatedBy], [Text]) VALUES (4, N'abc                                                                                                 ', NULL, CAST(10.00 AS Numeric(18, 2)), N'Demo Coupon', N'Active', NULL, N'#000000', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblCoupon] ([CouponID], [CouponCode], [DiscountType], [Discount], [Description], [CouponStatus], [CouponLink], [CouponColor], [TimesUsed], [CreatedDate], [CreatedBy], [Text]) VALUES (5, N'Bumper Offer                                                                                        ', NULL, CAST(10.00 AS Numeric(18, 2)), N'Limited offer Hurry Up', N'Active', NULL, N'#000000', NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblCoupon] OFF
GO
SET IDENTITY_INSERT [dbo].[tblFavourite] ON 
GO
INSERT [dbo].[tblFavourite] ([FavouriteID], [ProductID], [UserID], [CreateDate]) VALUES (46, 9, 2, CAST(N'2022-02-03T10:31:18.803' AS DateTime))
GO
INSERT [dbo].[tblFavourite] ([FavouriteID], [ProductID], [UserID], [CreateDate]) VALUES (51, 10, 1, CAST(N'2022-02-04T18:48:20.557' AS DateTime))
GO
INSERT [dbo].[tblFavourite] ([FavouriteID], [ProductID], [UserID], [CreateDate]) VALUES (52, 11, 1, CAST(N'2022-02-04T18:48:24.127' AS DateTime))
GO
INSERT [dbo].[tblFavourite] ([FavouriteID], [ProductID], [UserID], [CreateDate]) VALUES (65, 17, 1, CAST(N'2022-03-10T19:23:14.953' AS DateTime))
GO
INSERT [dbo].[tblFavourite] ([FavouriteID], [ProductID], [UserID], [CreateDate]) VALUES (66, 9, 1, CAST(N'2022-03-15T10:05:39.857' AS DateTime))
GO
INSERT [dbo].[tblFavourite] ([FavouriteID], [ProductID], [UserID], [CreateDate]) VALUES (1068, 14, 1, CAST(N'2022-04-08T10:14:03.690' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[tblFavourite] OFF
GO
SET IDENTITY_INSERT [dbo].[tblglassPicture] ON 
GO
INSERT [dbo].[tblglassPicture] ([PictureID], [glassID], [ImagePath]) VALUES (22, 24, N'/ProjectImages/AccessoryImage/additional-right-img_(1).png')
GO
SET IDENTITY_INSERT [dbo].[tblglassPicture] OFF
GO
SET IDENTITY_INSERT [dbo].[tblOrder] ON 
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (1, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'InProgress', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-05' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (3, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (4, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(114.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (5, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(114.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (6, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (7, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(114.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (8, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-07' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (9, 2, N'Bilal Saeed', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(585.65 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-02-11' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 4, N'abc                                                                                                 ', 60.7, 10)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (12, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(238.95 AS Numeric(18, 2)), NULL, NULL, N'asd', CAST(N'2022-03-15' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2022, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(1330.95 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2023, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(481.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2024, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2025, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(21.60 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2026, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(21.60 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2027, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2028, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2029, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2030, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2031, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2032, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2033, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2034, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2035, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(324.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2036, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(324.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2037, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2038, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(166.50 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-14' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2039, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(228.45 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-18' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2040, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(114.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-18' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2041, 1021, N'hasan bilal ', N'bilalsaeed666@gmail.com', N'Not Started', NULL, CAST(114.00 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-18' AS Date), NULL, N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'Lahore', N'Punjab', N'54000', N'Pakistan', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2042, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(228.45 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-21' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2043, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(228.45 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-21' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2044, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(228.45 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-21' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2045, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(228.45 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-21' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
INSERT [dbo].[tblOrder] ([OrderID], [userID], [UserName], [UserEmail], [Status], [IsPaid], [Total], [Vision], [LensType], [OrderComments], [OrderDate], [UserAddress], [BFname], [BLname], [BAddress], [Bcity], [BState], [BPostalCode], [BCountry], [BPhone], [BEmail], [SFname], [SLname], [SAddress], [Scity], [SState], [SPostalCode], [SCountry], [SPhone], [SEmail], [CouponID], [CouponCode], [Discountamount], [Discountpercentage]) VALUES (2046, 1, N'Hasan Bilal', N'hasanbilal369@gmail.com', N'Not Started', NULL, CAST(228.45 AS Numeric(18, 2)), NULL, NULL, NULL, CAST(N'2022-04-21' AS Date), N'352-R1 Johar town lahore', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', N'Bilal ', N'Saeed', N'Lahore', N'San Jose', N'CA', N'95113', N'US', N'123', N'hasanbilal369@gmail.com', 0, NULL, 0, 0)
GO
SET IDENTITY_INSERT [dbo].[tblOrder] OFF
GO
SET IDENTITY_INSERT [dbo].[tblOrderDetails] ON 
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (1, 2, 14, N'bilal', N'150', CAST(N'2022-02-07T12:54:28.870' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-three.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2, 4, 1, N'JinJIn Glass', N'100', CAST(N'2022-02-07T12:56:03.830' AS DateTime), N'', N'', N'', N'100', 0, 1, 5, 0, N'#8C001A', N'/ProjectImages/Variations/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Quarter.png', 9, 100)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (3, 6, 14, N'bilal', N'150', CAST(N'2022-02-07T13:00:35.810' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-three.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (4, 7, 1, N'JinJIn Glass', N'100', CAST(N'2022-02-07T13:40:25.403' AS DateTime), N'', N'', N'', N'100', 0, 1, 5, 0, N'#000000', N'/ProjectImages/Variations/1857-GOLD46__LOKAHI_1857-O-GOLD-46-22-145__2500x1400-Quarter.png', 9, 100)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (5, 8, 9, N'Ola Optical', N'150', CAST(N'2022-02-07T19:21:32.553' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (6, 9, 11, N'abdul', N'150', CAST(N'2022-02-11T17:56:24.360' AS DateTime), N'Reading', N'Premium Coatings', N'on', N'209', 9, 1, 30.35, 10, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', 9, 229)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (7, 9, 11, N'abdul', N'150', CAST(N'2022-02-11T17:56:24.423' AS DateTime), N' ', N'Standard', N'on', N'209', 9, 1, 30.35, 10, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (8, 9, 9, N'Ola Optical', N'150', CAST(N'2022-02-11T17:56:24.443' AS DateTime), N'Reading', N'Enhanced', N'on', N'219', 7, 1, 30.35, 10, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', NULL, 288)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (9, 10, 16, N'nauman', N'150', CAST(N'2022-03-10T17:44:27.037' AS DateTime), N'', N'', N'', N'300', 0, 2, 22.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 300)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (10, 10, 16, N'nauman', N'150', CAST(N'2022-03-10T17:44:27.053' AS DateTime), N'', N'', N'', N'300', 0, 2, 30, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 300)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (11, 10, 16, N'nauman', N'150', CAST(N'2022-03-10T17:44:27.057' AS DateTime), N'', N'', N'', N'150', 0, 1, NULL, NULL, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (12, 10, 9, N'Ola Optical', N'150', CAST(N'2022-03-10T17:44:27.060' AS DateTime), N' ', N'Enhanced', N'off', N'199', 7, 1, 62.45, 0, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', 9, 248)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (13, 10, 16, N'nauman', N'150', CAST(N'2022-03-10T17:44:27.067' AS DateTime), N'', N'', N'', N'150', 0, 1, NULL, NULL, NULL, N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (14, 10, 9, N'Ola Optical', N'150', CAST(N'2022-03-10T17:44:27.070' AS DateTime), N'', N'', N'', N'150', 0, 1, NULL, NULL, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (15, 11, 16, N'nauman', N'150', CAST(N'2022-03-15T10:07:01.030' AS DateTime), N'', N'', N'', N'150', 0, 1, 15, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (16, 11, 14, N'bilal', N'150', CAST(N'2022-03-15T10:07:01.140' AS DateTime), N'', N'', N'', N'150', 0, 1, NULL, NULL, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (17, 12, 9, N'Ola Optical', N'150', CAST(N'2022-03-15T11:46:00.610' AS DateTime), N' ', N'Enhanced', N'on', N'219', 7, 1, 10.95, 0, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', NULL, 288)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (18, 13, 16, N'nauman', N'150', CAST(N'2022-03-15T11:56:15.270' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (19, 15, 16, N'nauman', N'150', CAST(N'2022-03-15T15:36:58.473' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (20, 16, 16, N'nauman', N'150', CAST(N'2022-03-15T16:34:29.550' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (21, 17, 16, N'nauman', N'150', CAST(N'2022-03-15T16:48:51.220' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (22, 19, 16, N'nauman', N'150', CAST(N'2022-03-15T16:54:14.207' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (23, 20, 16, N'nauman', N'150', CAST(N'2022-03-15T16:57:45.470' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (24, 21, 16, N'nauman', N'150', CAST(N'2022-03-15T17:04:39.313' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (25, 22, 16, N'nauman', N'150', CAST(N'2022-03-15T17:30:42.040' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (26, 23, 16, N'nauman', N'150', CAST(N'2022-03-15T17:38:04.197' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (27, 24, 16, N'nauman', N'150', CAST(N'2022-03-15T18:19:07.703' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (1015, 1011, 16, N'nauman', N'150', CAST(N'2022-03-15T21:12:31.907' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (1016, 1012, 9, N'Ola Optical', N'150', CAST(N'2022-03-16T00:34:14.900' AS DateTime), N'Reading', N'Enhanced', N'on', N'219', 7, 1, 10.95, 0, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', 9, 288)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (1017, 1013, 14, N'bilal', N'150', CAST(N'2022-03-16T00:37:03.463' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2015, 2011, 16, N'nauman', N'150', CAST(N'2022-04-02T10:39:32.143' AS DateTime), N'', N'', N'', N'450', 0, 3, 27.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 450)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2016, 2011, 1, N'JinJIn Glass', N'100', CAST(N'2022-04-02T10:39:32.153' AS DateTime), N'', N'', N'', N'100', 0, 1, 27.5, 0, N'#665D1E', N'/ProjectImages/Variations/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 100)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2017, 2012, 1, N'JinJIn Glass', N'100', CAST(N'2022-04-02T10:43:55.873' AS DateTime), N'', N'', N'', N'300', 0, 3, 15, 0, N'#665D1E', N'/ProjectImages/Variations/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 300)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2018, 2013, 16, N'nauman', N'150', CAST(N'2022-04-04T15:49:28.830' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2019, 2014, 9, N'Ola Optical', N'150', CAST(N'2022-04-08T10:04:21.390' AS DateTime), N'Reading', N'Premium Coatings', N'on', N'219', 7, 1, 10.95, 0, N'#665D1E', N'/ProjectImages/Variations/additional-right-img.png', 9, 239)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2020, 2015, 9, N'Ola Optical', N'150', CAST(N'2022-04-08T10:11:41.577' AS DateTime), N'Reading', N'Premium Coatings', N'on', N'219', 7, 1, 10.95, 0, N'#665D1E', N'/ProjectImages/Variations/placeholder.jpg', 9, 239)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2021, 2016, 9, N'Ola Optical', N'150', CAST(N'2022-04-08T10:56:54.203' AS DateTime), N'Reading', N'Standard', N'on', N'209', 19, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/placeholder.jpg', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2022, 2017, 9, N'Ola Optical', N'150', CAST(N'2022-04-08T11:01:48.147' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/Capture.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2023, 2018, 9, N'Ola Optical', N'150', CAST(N'2022-04-08T11:19:27.560' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/Capture.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2024, 2019, 9, N'Ola Optical', N'150', CAST(N'2022-04-08T11:21:38.427' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/Capture.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2025, 2020, 1, N'JinJIn Glass', N'100', CAST(N'2022-04-11T14:01:56.093' AS DateTime), N'', N'', N'', N'100', 0, 1, 12.5, 0, N'#665D1E', N'/ProjectImages/Variations/5.jpg', 9, 100)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2026, 2020, 16, N'nauman', N'150', CAST(N'2022-04-11T14:01:56.117' AS DateTime), N'', N'', N'', N'150', 0, 1, 12.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2027, 2021, 14, N'bilal', N'150', CAST(N'2022-04-11T14:51:06.447' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2028, 2022, 14, N'bilal', N'150', CAST(N'2022-04-14T16:57:04.927' AS DateTime), N'', N'', N'', N'150', 0, 1, 62.95, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2029, 2022, 9, N'Ola Optical', N'150', CAST(N'2022-04-14T16:57:04.953' AS DateTime), N'Reading', N'Standard', N'on', N'1463', 7, 7, 62.95, 0, N'#665D1E', N'/ProjectImages/Variations/Capture.png', 9, 1522)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2030, 2023, 16, N'nauman', N'150', CAST(N'2022-04-14T17:05:36.530' AS DateTime), N'', N'', N'', N'450', 0, 3, 22.5, 0, N'zz', N'/ProjectImages/AccessoryImage/glasses-four.png', 9, 450)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2031, 2024, 14, N'bilal', N'150', CAST(N'2022-04-14T17:13:46.843' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2032, 2025, 21, N'Demo', N'12', CAST(N'2022-04-14T17:20:40.300' AS DateTime), N'', N'', N'', N'12', 0, 1, 0.6, 0, N'zz', N'/ProjectImages/AccessoryImage/4373.jpg', 9, 12)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2033, 2027, 14, N'bilal', N'150', CAST(N'2022-04-14T17:23:32.057' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2034, 2031, 14, N'bilal', N'150', CAST(N'2022-04-14T17:31:34.017' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2035, 2034, 14, N'bilal', N'150', CAST(N'2022-04-14T20:01:23.780' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2036, 2035, 14, N'bilal', N'150', CAST(N'2022-04-14T20:45:14.817' AS DateTime), N'', N'', N'', N'300', 0, 2, 15, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 300)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2037, 2036, 14, N'bilal', N'150', CAST(N'2022-04-14T20:52:40.687' AS DateTime), N'', N'', N'', N'150', 0, 1, 15, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2038, 2036, 14, N'bilal', N'150', CAST(N'2022-04-14T20:52:40.690' AS DateTime), N'', N'', N'', N'150', 0, 1, 15, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2039, 2037, 14, N'bilal', N'150', CAST(N'2022-04-14T20:54:38.293' AS DateTime), N'', N'', N'', N'150', 0, 1, 7.5, 0, N'zz', N'/ProjectImages/AccessoryImage/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Front.png', 9, 150)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2040, 2039, 9, N'Ola Optical', N'150', CAST(N'2022-04-18T19:41:05.777' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/Capture.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2041, 2040, 1, N'JinJIn Glass', N'100', CAST(N'2022-04-18T19:47:37.170' AS DateTime), N'', N'', N'', N'100', 0, 1, 5, 0, N'#665D1E', N'/ProjectImages/Variations/Callen-1.png', 9, 100)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2042, 2041, 24, N'Ola Accessory', N'100', CAST(N'2022-04-18T20:07:29.890' AS DateTime), N'', N'', N'', N'100', 0, 1, NULL, NULL, N'zz', N'/ProjectImages/AccessoryImage/additional-right-img_(1).png', 9, 100)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2043, 2042, 9, N'Ola Optical', N'150', CAST(N'2022-04-21T12:14:20.937' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/TR92196-C3__OLA_TR92196-O-C3-55-20-139__2500x1400-Front.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2044, 2044, 9, N'Ola Optical', N'150', CAST(N'2022-04-21T12:35:18.077' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/Capture.png', NULL, 268)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2045, 2045, 9, N'Ola Optical', N'150', CAST(N'2022-04-21T12:38:19.417' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/TR92196-C3__OLA_TR92196-O-C3-55-20-139__2500x1400-Front.png', NULL, 209)
GO
INSERT [dbo].[tblOrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Productname], [ProductPrice], [OrderDate], [Vision], [LensType], [UV_Protection], [Total], [ProductVariation], [quantity], [TaxAmount], [Discount], [FrameColor], [ProductImage], [ShippingAmount], [Subtotal]) VALUES (2046, 2046, 9, N'Ola Optical', N'150', CAST(N'2022-04-21T12:45:06.177' AS DateTime), N'Reading', N'Standard', N'on', N'209', 7, 1, 10.45, 0, N'#665D1E', N'/ProjectImages/Variations/TR92196-C3__OLA_TR92196-O-C3-55-20-139__2500x1400-Front.png', 9, 209)
GO
SET IDENTITY_INSERT [dbo].[tblOrderDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[tblOrderPrescription] ON 
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (2, 1, 1, N'2', N'-0.25', N'0', N'3.25', N'1', N'0', N'0', N'4', NULL, NULL, N'Abdul', N'Qadeer', N'Yes', CAST(N'2021-12-01' AS Date), 54, 1, N'\ProjectImages\Prescription\EditProperty.png', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (3, NULL, 0, N'2', N'-0.25', N'0', N'3.25', N'1', N'-1', N'0', N'4', NULL, NULL, N'Abdul', N'Qadeer', N'Yes', CAST(N'2021-12-01' AS Date), 54, 1, N'\ProjectImages\Prescription\EditProperty.png', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (4, 1, 6, N'8', N'2.75', N'12', N'0.25', N'8', N'-0.5', N'12', N'2.25', N'Reading', 1, N'ad', N'sdf', N'Yes', CAST(N'2022-01-26' AS Date), 56, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (5, 1, 6, N'8', N'-2.25', N'12', N'4.5', N'8', N'-2', N'12', N'4.5', N'Reading', 1, N'sdf', N'sfd', N'Yes', CAST(N'2021-12-31' AS Date), 61, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (6, 1, 7, N'8', N'2.75', N'12', N'0.25', N'8', N'-0.5', N'12', N'2.25', N'Reading', 1, N'ad', N'sdf', N'Yes', CAST(N'2022-01-26' AS Date), 56, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (7, 1, 8, N'8', N'2.75', N'12', N'0.25', N'8', N'-0.5', N'12', N'2.25', N'Reading', 1, N'ad', N'sdf', N'Yes', CAST(N'2022-01-26' AS Date), 56, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (8, 1, 10, N'8', N'2.75', N'12', N'0.25', N'8', N'-0.5', N'12', N'2.25', N'Distance', 1, NULL, NULL, N'Yes', NULL, 56, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (9, 1, 11, N'8', N'2.75', N'12', N'0.25', N'8', N'-0.5', N'12', N'2.25', N'Distance', 1, NULL, NULL, N'Yes', NULL, 56, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (10, 1, 11, N'-2.75', N'-1.75', N'12', N'5.25', N'8', N'-1.75', N'1', N'4.75', N'Reading', 1, N'da', N'ads', N'Yes', CAST(N'2022-01-04' AS Date), 44, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (11, 1, 13, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'Yes', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (12, 9, 17, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'Yes', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (13, 9, 18, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'Yes', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (14, 9, 19, N'8', N'-1.25', N'12', N'4.75', N'8', N'-1.25', N'12', N'4.25', N'Reading', 1, N'da', N'sfd', N'Yes', CAST(N'2022-01-19' AS Date), 47, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (15, 9, 20, N'8', N'2.75', N'12', N'0.25', N'8', N'-0.5', N'12', N'2.25', N'Distance', 1, NULL, NULL, N'Yes', NULL, 56, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (16, 9, 23, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (17, 9, 24, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (18, 9, 24, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (19, 9, 25, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 2, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (20, 11, 25, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (21, 9, 28, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (22, 9, 33, N'8', N'0', NULL, N'0', N'8', N'0', NULL, N'0', N'Reading', 1, N'ads', N'asd', N'No', CAST(N'2022-01-28' AS Date), 46, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (23, 11, 33, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N' ', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (24, 11, 34, N'8', N'0', NULL, N'0', N'8', N'0', NULL, N'0', N'Reading', 1, N'd', N'sfd', N'Yes', CAST(N'2022-01-21' AS Date), 44, 1, N'/ProjectImages/Prescription/11/1-PDImage-11.png', N'/ProjectImages/Prescription/11/1-PrescriptionImage-11.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (25, 11, 9, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'Reading', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (26, 9, 9, N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'0', N'Reading', 1, NULL, NULL, N'No', NULL, 0, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (27, 9, 1012, N'8', N'0', NULL, N'0', N'8', N'0', NULL, N'0', N'Reading', 1, N'hasan', N'bilal', N'No', CAST(N'2022-03-01' AS Date), 44, 2, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (28, 9, 2014, N'+7.25', N'-1.00', N'12', N'4.25', N'+6.50', N'-1.75', N'44', N'4.25', N'Reading', 1, N'yazdan', N'syed', N'yazdan369', CAST(N'2022-04-04' AS Date), 45, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (29, 9, 2015, N'+7.25', N'-1.00', N'12', N'4.25', N'+6.50', N'-1.75', N'44', N'4.25', N'Reading', 1, N'yazdan', N'syed', N'yazdan369', CAST(N'2022-04-04' AS Date), 45, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (30, 9, 2016, N'+7.25', N'-1.00', N'12', N'4.25', N'+6.50', N'-1.75', N'44', N'4.25', N'Reading', 1, N'yazdan', N'syed', N'yazdan369', CAST(N'2022-04-04' AS Date), 45, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (31, 9, 2017, N'+8.00', N'-0.50', N'1', N'0.75', N'+4.00', N'-1.00', N'5', N'3.00', N'Reading', 1, N'Abdul', N'Qadeer', N'qadeer786', CAST(N'2022-04-08' AS Date), 45, 2, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (32, 9, 2018, N'+8.00', N'-0.50', N'1', N'0.75', N'+4.00', N'-1.00', N'5', N'3.00', N'Reading', 1, N'Abdul', N'Qadeer', N'qadeer786', CAST(N'2022-04-08' AS Date), 45, 2, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (33, 9, 2019, N'+7.75', N'-0.50', N'33', N'4.50', N'+8.00', N'0.00', N'45', N'4.50', N'Reading', 1, N'Hasan ', N'Bilal', N'Qadeerkhici963', CAST(N'2022-11-11' AS Date), 48, 2, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (34, 9, 2022, N'+7.25', N'-1.00', N'12', N'4.25', N'+6.50', N'-1.75', N'44', N'4.25', N'Reading', 7, N'yazdan', N'syed', N'yazdan369', CAST(N'2022-04-14' AS Date), 45, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (35, 9, 2039, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Reading', 1, N'hasan ', N'bilal', N'hasanbilal369', CAST(N'2022-04-18' AS Date), 45, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (36, 9, 2042, N'+8.00', N'0.00', N'12', N'0.00', N'+8.00', N'0.00', N'15', N'0.00', N'Reading', 1, N'Yazdan', N'Ali', N'yazdan123', CAST(N'2022-04-21' AS Date), 44, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (37, 9, 2044, N'+7.50', N'2.75', N'12', N'0.50', N'+8.00', N'2.25', N'54', N'0.75', N'Reading', 1, N'Qadeer', N'Khan', N'Qadeerkhici963', CAST(N'2022-04-18' AS Date), 45, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (38, 9, 2045, N'+7.50', N'2.75', N'12', N'0.50', N'+8.00', N'2.25', N'54', N'0.75', N'Reading', 1, N'Qadeer', N'Khan', N'Qadeerkhici963', CAST(N'2022-04-18' AS Date), 45, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblOrderPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (39, 9, 2046, N'+7.50', N'2.75', N'12', N'0.50', N'+8.00', N'2.25', N'54', N'0.75', N'Reading', 1, N'Qadeer', N'Khan', N'Qadeerkhici963', CAST(N'2022-04-18' AS Date), 45, 1, N'', N'', NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblOrderPrescription] OFF
GO
SET IDENTITY_INSERT [dbo].[tblProduct] ON 
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (1, N'JinJIn Glass', N'Aviator', NULL, N'Plastic', NULL, N'Women', NULL, NULL, 100, 100, NULL, N'Ola Company', NULL, N'00013', N'x002', N'Semi-Rim', N'Top Seller', N'Spring Hinge', N'Sunglass', 1, NULL, N'No', NULL, N'P9854-BLUE')
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (3, N'Glass Cover', N'Round', NULL, N'Titanium', NULL, N'Women', NULL, N'Large', 100, 100, NULL, N'Ola Company', NULL, NULL, NULL, NULL, N'Hot', NULL, N'Sunglass', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (7, N'Lens Clear', N'Square', NULL, N'Plastic', NULL, N'Women', NULL, N'Small', 12, 12, NULL, N'Ola Company', NULL, NULL, NULL, NULL, N'Top Seller', NULL, N'Sunglass', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (8, N'Ola Glass', N'Rectangle', NULL, N'Plastic Metal', NULL, N'UniSex', NULL, N'Large', 250, 250, NULL, N'Xyz Company', NULL, N'00012', N'x001', N'Rimless', N'New Arrival', N'Nose Pad', N'Sunglass', 1, NULL, N'Yes', NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (9, N'Ola Optical', N'Rectangle', NULL, N'Plastic Metal', NULL, N'Men', NULL, NULL, 150, 150, NULL, N'ola optical', NULL, N'0002', N'00002', N'Rimless', N'New Arrival', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, N'')
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (10, N'Accessori', N'Polygon', NULL, N'Titanium', NULL, N'Women', NULL, N'Large', 15, 5, NULL, N'xyz', NULL, NULL, NULL, NULL, N'New Arrival', NULL, N'Sunglass', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (11, N'abdul', N'Rectangle', NULL, N'Plastic Metal', NULL, N'Men', NULL, N'Medium', 150, 150, NULL, N'ola optical', NULL, N'0002', N'00002', N'Rimless', N'Top Seller', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (12, N'qadeer', N'Cart Eye', NULL, N'Titanium', NULL, N'UniSex', NULL, N'Small', 150, 150, NULL, N'ola optical', NULL, N'0002', N'00002', N'Rimless', N'Hot', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (13, N'asad', N'Polygon', NULL, N'Plastic', NULL, N'UniSex', NULL, N'Small', 150, 150, NULL, N'ola optical', NULL, N'0002', N'00002', N'Rimless', N'New Arrival', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (15, N'saeed', N'Polygon', NULL, N'Plastic Metal', NULL, N'UniSex', NULL, N'Large', 150, 150, NULL, N'ola optical', NULL, N'0002', N'00002', N'Rimless', N'Top Seller', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (17, N'hasan', N'Aviator', NULL, N'Titanium', NULL, N'Men', NULL, N'Medium', 150, 150, NULL, N'ola optical', NULL, N'0002', N'00002', N'Rimless', N'New Arrival', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, NULL)
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (19, N'Blue Ray', N'Rectangle', NULL, N'Metal', NULL, N'Men', NULL, NULL, 10, 5, NULL, N'Hasn', NULL, N'123', N'abc-123', N'Rimless', N'Hot', N'Nose Pad', N'Sunglass', 1, NULL, N'Yes', NULL, N'LK-116-C4')
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (22, N'Prada New Glass', N'Rectangle', NULL, N'Metal', NULL, N'Men', NULL, NULL, 10, 7, NULL, N'Bilal Optics', NULL, N'AA123', N'abc-123', N'Rimless', N'Top Seller', N'Nose Pad', N'Eyeglass', 1, NULL, N'Yes', NULL, N'')
GO
INSERT [dbo].[tblProduct] ([GlassID], [Title], [shape], [Colour], [Material], [Brand], [Gender], [AdditionalInfo], [AvailableSize], [Price], [Cost], [CreatedDate], [Manufacturer], [Model], [OrignalCode], [Mgf_Code], [Rim], [Sticker], [Feature], [ProductCategory], [ReleatedTo], [Clicks], [SellinClinic], [ImagePath], [SKUNumber]) VALUES (24, N'Ola Accessory', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, 50, NULL, N'Ola optics', NULL, NULL, NULL, NULL, NULL, NULL, N'Accessory', NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblProduct] OFF
GO
SET IDENTITY_INSERT [dbo].[tblpromotionoffer] ON 
GO
INSERT [dbo].[tblpromotionoffer] ([Promotionid], [description], [colorcode], [colorname], [isActive]) VALUES (1, N'Special Offer Discount Limited', N'#665D1E', N'Antique', 1)
GO
SET IDENTITY_INSERT [dbo].[tblpromotionoffer] OFF
GO
SET IDENTITY_INSERT [dbo].[tblReviewLike] ON 
GO
INSERT [dbo].[tblReviewLike] ([ReviewLikeID], [ReviewID], [UserID], [Productid]) VALUES (76, 2115, 1, 9)
GO
INSERT [dbo].[tblReviewLike] ([ReviewLikeID], [ReviewID], [UserID], [Productid]) VALUES (84, 2114, 1, 1)
GO
INSERT [dbo].[tblReviewLike] ([ReviewLikeID], [ReviewID], [UserID], [Productid]) VALUES (85, 2138, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[tblReviewLike] OFF
GO
SET IDENTITY_INSERT [dbo].[tblReviews] ON 
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2115, 1, 9, 5, N' i AM NEE', CAST(N'2022-04-11T12:06:39.783' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/Web application.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2116, 1, 9, 5, N' Dumy review', CAST(N'2022-04-18T17:45:54.513' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/Bilal Saeed.jpeg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2165, 1, 1, 5, N' Frist', CAST(N'2022-04-20T13:11:41.120' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/Untitled.png', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2166, 1, 1, 5, N' asd', CAST(N'2022-04-20T13:12:08.447' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/WhatsApp Image 2021-06-14 at 4.18.29 PM.jpeg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2167, 1, 1, 5, N' Aho', CAST(N'2022-04-20T13:13:01.300' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/Web application.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2168, 1, 1, 5, N' zsdf', CAST(N'2022-04-20T13:14:18.700' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/WhatsApp Image 2021-06-1  at 1.45.45 PM.jpeg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2196, 1, 22, 5, N' First Review', CAST(N'2022-04-21T16:52:26.847' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/20151018_075223.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2197, 1, 22, 5, N'Second Review', CAST(N'2022-04-21T16:52:37.487' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/20151018_075229.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2198, 1, 22, 5, N' Thrid Reviww', CAST(N'2022-04-21T16:53:04.673' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/20151018_075414.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2199, 1, 22, 5, N' ad', CAST(N'2022-04-21T17:07:02.303' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/14705760_1963360433890815_2877509173085406673_n.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2200, 1, 22, 5, N'', CAST(N'2022-04-21T17:07:07.467' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/12208713_824222984362033_1058889259817041093_n.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2201, 1, 22, 5, N'', CAST(N'2022-04-21T17:07:13.843' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/Bilal Saeed.jpeg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2202, 1, 22, 5, N'', CAST(N'2022-04-21T17:07:20.130' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/Cricket.jpg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
INSERT [dbo].[tblReviews] ([ReviewID], [UserID], [GlassID], [Rating], [Review], [CreatedDate], [ReviewImage], [UserName], [UserImage]) VALUES (2203, 1, 22, 5, N'asd', CAST(N'2022-04-21T17:07:27.647' AS DateTime), N'/ProjectImages/Uploads/Reviews/1/WhatsApp Image 2021-06-1  at 1.45.45 PM.jpeg', N'Hasan Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg')
GO
SET IDENTITY_INSERT [dbo].[tblReviews] OFF
GO
SET IDENTITY_INSERT [dbo].[tblSettings] ON 
GO
INSERT [dbo].[tblSettings] ([ID], [clientId], [clientSecret], [AccountType], [Email], [Password], [SMTP], [Port], [IsActive], [StripeID], [ReceipentEmail]) VALUES (3, N'xx', N'xx', N'xx', N'restock06@gmail.com', N'Developer@123', N'smtp.gmail.com', N'587', 1, N'sk_test_51KCNvMAAmezOUSgHzvzlmVPJbRdOjcsDpuFRpvurc3vR5OlfBlWSVcmDMfaY0s00s9BjUVCjteBTbZIs9WLjpuP600fhBe83Gy', N'abdulqadeerkhan070@gmail.com')
GO
SET IDENTITY_INSERT [dbo].[tblSettings] OFF
GO
SET IDENTITY_INSERT [dbo].[tblSizes] ON 
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (1, N'PD', N'0')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (2, N'PD', N'44')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (3, N'PD', N'45')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (4, N'PD', N'46')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (5, N'PD', N'47')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (6, N'PD', N'48')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (7, N'PD', N'49')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (8, N'PD', N'50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (9, N'PD', N'51')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (10, N'PD', N'52')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (11, N'PD', N'53')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (12, N'PD', N'54')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (13, N'PD', N'55')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (14, N'PD', N'56')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (15, N'PD', N'57')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (16, N'PD', N'58')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (17, N'PD', N'59')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (18, N'PD', N'60')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (19, N'PD', N'61')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (20, N'PD', N'62')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (21, N'PD', N'63')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (22, N'PD', N'64')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (23, N'PD', N'65')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (24, N'PD', N'66')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (25, N'PD', N'67')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (26, N'PD', N'68')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (27, N'PD', N'69')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (28, N'PD', N'70')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (29, N'PD', N'71')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (30, N'PD', N'72')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (31, N'PD', N'73')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (32, N'SPH', N'+8.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (33, N'SPH', N'+7.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (34, N'SPH', N'+7.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (35, N'SPH', N'+7.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (36, N'SPH', N'+7.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (37, N'SPH', N'+6.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (38, N'SPH', N'+6.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (39, N'SPH', N'+6.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (40, N'SPH', N'+6.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (41, N'SPH', N'+5.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (42, N'SPH', N'+5.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (43, N'SPH', N'+5.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (44, N'SPH', N'+5.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (45, N'SPH', N'+4.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (46, N'SPH', N'+4.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (47, N'SPH', N'+4.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (48, N'SPH', N'+4.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (49, N'SPH', N'+3.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (50, N'SPH', N'+3.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (51, N'SPH', N'+3.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (52, N'SPH', N'+3.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (53, N'SPH', N'+2.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (54, N'SPH', N'+2.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (55, N'SPH', N'+2.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (56, N'SPH', N'+2.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (57, N'SPH', N'+1.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (58, N'SPH', N'+1.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (59, N'SPH', N'+1.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (60, N'SPH', N'+1.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (61, N'SPH', N'+0.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (62, N'SPH', N'+0.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (63, N'SPH', N'+0.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (64, N'SPH', N'+0.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (65, N'SPH', N'-0.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (66, N'SPH', N'-0.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (67, N'SPH', N'-0.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (68, N'SPH', N'-1.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (69, N'SPH', N'-1.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (70, N'SPH', N'-1.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (71, N'SPH', N'-1.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (72, N'SPH', N'-2.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (73, N'SPH', N'-2.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (74, N'SPH', N'-2.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (75, N'SPH', N'-2.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (76, N'SPH', N'-3.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (77, N'SPH', N'-3.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (78, N'SPH', N'-3.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (79, N'SPH', N'-3.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (80, N'SPH', N'-4.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (81, N'SPH', N'-4.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (82, N'SPH', N'-4.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (83, N'SPH', N'-4.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (84, N'SPH', N'-5.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (85, N'SPH', N'-5.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (86, N'SPH', N'-5.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (87, N'SPH', N'-5.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (88, N'SPH', N'-6.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (89, N'SPH', N'-6.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (90, N'SPH', N'-6.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (91, N'SPH', N'-6.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (92, N'SPH', N'-7.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (93, N'SPH', N'-7.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (94, N'SPH', N'-7.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (95, N'SPH', N'-7.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (96, N'SPH', N'-8.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (97, N'ADD', N'0.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (98, N'ADD', N'0.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (99, N'ADD', N'0.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (100, N'ADD', N'0.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (101, N'ADD', N'1.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (102, N'ADD', N'1.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (103, N'ADD', N'1.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (104, N'ADD', N'1.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (105, N'ADD', N'2.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (106, N'ADD', N'2.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (107, N'ADD', N'2.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (108, N'ADD', N'2.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (109, N'ADD', N'3.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (110, N'ADD', N'3.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (111, N'ADD', N'3.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (112, N'ADD', N'3.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (113, N'ADD', N'4.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (114, N'ADD', N'4.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (115, N'ADD', N'4.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (116, N'ADD', N'4.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (117, N'ADD', N'5.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (118, N'ADD', N'5.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (119, N'ADD', N'5.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (120, N'ADD', N'5.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (121, N'CYL', N'0.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (122, N'CYL', N'3.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (123, N'CYL', N'2.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (124, N'CYL', N'2.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (125, N'CYL', N'2.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (126, N'CYL', N'2.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (127, N'CYL', N'1.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (128, N'CYL', N'1.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (129, N'CYL', N'1.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (130, N'CYL', N'1.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (131, N'CYL', N'0.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (132, N'CYL', N'0.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (133, N'CYL', N'0.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (135, N'CYL', N'-0.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (136, N'CYL', N'-0.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (137, N'CYL', N'-0.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (138, N'CYL', N'-1.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (139, N'CYL', N'-1.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (140, N'CYL', N'-1.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (141, N'CYL', N'-1.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (142, N'CYL', N'-2.00')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (143, N'CYL', N'-2.25')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (144, N'CYL', N'-2.50')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (145, N'CYL', N'-2.75')
GO
INSERT [dbo].[tblSizes] ([SizeID], [Type], [TypeValue]) VALUES (146, N'CYL', N'-3.00')
GO
SET IDENTITY_INSERT [dbo].[tblSizes] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUser] ON 
GO
INSERT [dbo].[tblUser] ([UserID], [UserEmail], [UserPass], [Address], [Phone], [Role], [Firstname], [Lastname], [UserImage], [DateofBirth], [Gender], [UserStatus], [CreatedDate], [FaxNumber]) VALUES (1, N'hasanbilal369@gmail.com', N'CE3KYQHUwos=', N'352-R1 Johar town lahore', N'03212121066', N'admin', N'Hasan', N'Bilal', N'\ProjectImages\UserImages\Abdul_1.jpeg', NULL, N'Male', 1, CAST(N'2022-03-10T12:20:48.217' AS DateTime), NULL)
GO
INSERT [dbo].[tblUser] ([UserID], [UserEmail], [UserPass], [Address], [Phone], [Role], [Firstname], [Lastname], [UserImage], [DateofBirth], [Gender], [UserStatus], [CreatedDate], [FaxNumber]) VALUES (1021, N'bilalsaeed666@gmail.com', N'CE3KYQHUwos=', NULL, NULL, N'Candidate', N'hasan bilal', NULL, N'https://lh3.googleusercontent.com/a-/AOh14GhqdhZ5I-m3jWYlQgSFn8u_8BlSddidGQO0gHZjRw=s96-c', NULL, NULL, 2, NULL, NULL)
GO
INSERT [dbo].[tblUser] ([UserID], [UserEmail], [UserPass], [Address], [Phone], [Role], [Firstname], [Lastname], [UserImage], [DateofBirth], [Gender], [UserStatus], [CreatedDate], [FaxNumber]) VALUES (1022, N'restock06@gmail.com', N'CE3KYQHUwos=', NULL, NULL, N'Candidate', N'Re Stock', NULL, N'https://lh3.googleusercontent.com/a/AATXAJzDpanCoKDj-sjUKZw73-LG7k4gh1I4iNFIH1yB=s96-c', NULL, NULL, 2, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblUser] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUserPrescription] ON 
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (19, 9, 0, N'+7.25', N'-1.00', N'12', N'4.25', N'+6.50', N'-1.75', N'44', N'4.25', N'Standard', 1, N'yazdan', N'syed', N'yazdan369', CAST(N'2022-04-04' AS Date), 45, 1021, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-19T14:04:51.000' AS DateTime), 64, N'Bifocal', 1)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (20, 9, 0, N'+8.00', N'-0.50', N'1', N'0.75', N'+4.00', N'-1.00', N'5', N'3.00', N'Standard', 1, N'Abdul', N'Qadeer', N'qadeer786', CAST(N'2022-04-08' AS Date), 45, 1021, N'/ProjectImages/Prescription/9/2-PDImage-9.png', N'/ProjectImages/Prescription/9/2-PrescriptionImage-9.png', CAST(N'2022-04-08T11:01:02.737' AS DateTime), 58, N'Bifocal', 1)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (22, 1, 2, N'+7.50', N'-2.00', N'12', N'4.50', N'+4.25', N'-1.00', N'12', N'4.25', N'3', 4, N'Syed Muhammad', N'Yazdadn', N'Yazdad123', CAST(N'2022-04-08' AS Date), 61, 1021, N'5', N'6', CAST(N'2022-04-11T12:07:35.000' AS DateTime), 0, N'8', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (26, 9, 0, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Standard', 1, N'Bilal', N'Saeed', N'yazdan369', CAST(N'2022-04-18' AS Date), 48, 1021, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T16:41:25.333' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (27, 9, 0, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Standard', 1, N'hasan ', N'bilal', N'hasanbilal3699', CAST(N'2022-04-18' AS Date), 45, 1021, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-19T14:12:19.000' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (28, 9, 0, N'+7.50', N'2.75', N'12', N'0.50', N'+8.00', N'2.25', N'54', N'0.75', N'Standard', 1, N'Qadeer', N'Khan', N'Qadeerkhici963', CAST(N'2022-04-18' AS Date), 45, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T21:34:09.497' AS DateTime), 50, N'Bifocal', 1)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (29, 9, 0, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Standard', 1, N'ads', N'asd', N'yazdan369', CAST(N'2022-04-18' AS Date), 58, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T22:05:04.000' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (30, 9, 0, N'+8.00', N'3.00', N'12', N'0.25', N'+8.00', N'3.00', N'12', N'0.25', N'Standard', 1, N'ads', N'asd', N'asadawan88', CAST(N'2022-04-18' AS Date), 44, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T22:14:16.723' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (31, 9, 0, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Standard', 1, N'ads', N'asd', N'yazdan369', CAST(N'2022-04-18' AS Date), 53, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T22:23:44.733' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (32, 9, 0, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Standard', 1, N'ads', N'asd', N'yazdan3692', CAST(N'2022-04-18' AS Date), 44, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T22:32:33.360' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (33, 9, 0, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', N'Standard', 1, N'ads', N'asd', N'ads', CAST(N'2022-04-18' AS Date), 57, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-18T22:45:23.243' AS DateTime), 0, N'Bifocal', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (36, NULL, NULL, N'+8.00', N'0.00', NULL, N'0.00', N'+8.00', N'0.00', NULL, N'0.00', NULL, NULL, N'Waqas', N'Ahmed', N'waqas369', CAST(N'2022-04-19' AS Date), 0, 1021, NULL, NULL, CAST(N'2022-04-19T14:16:47.000' AS DateTime), 0, NULL, 1)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (37, NULL, NULL, N'+6.75', N'2.75', N'44', N'0.25', N'+7.75', N'3.00', N'12', N'0.25', NULL, NULL, N'nauman', N'bin', N'nauambin996', CAST(N'2022-04-21' AS Date), 45, 1021, NULL, NULL, CAST(N'2022-04-20T10:45:42.000' AS DateTime), 0, NULL, 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (38, NULL, NULL, N'+8.00', N'0.00', N'22', N'4.25', N'+7.75', N'1.00', N'12', N'3.25', NULL, NULL, N'Mateen', N'Ahmed', N'Mateen366', CAST(N'2022-04-21' AS Date), 44, 1021, NULL, NULL, CAST(N'2022-04-20T10:48:08.000' AS DateTime), 0, NULL, 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (39, 9, 0, N'+8.00', N'0.00', N'12', N'0.00', N'+8.00', N'0.00', N'15', N'0.00', N'Standard', 1, N'Yazdan', N'Ali', N'yazdan123', CAST(N'2022-04-21' AS Date), 44, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-21T12:12:26.307' AS DateTime), 0, N'0.00', 0)
GO
INSERT [dbo].[tblUserPrescription] ([PrescriptionID], [ProductID], [OrderID], [r_sph], [r_cyl], [r_axis], [r_add], [l_sph], [l_cyl], [l_axis], [l_add], [lensType], [quantity], [Fname], [Lname], [prescription], [prescriptionDate], [PD], [UserID], [PDImage], [PrescriptionImage], [CreatedDate], [Rightpd], [Segmentheight], [Dualpd]) VALUES (40, 9, 0, N'+8.00', N'0.00', N'1', N'0.00', N'+8.00', N'0.00', N'5', N'0.00', N'Standard', 1, N'Asad', N'awan', N'asadawas22', CAST(N'2022-04-21' AS Date), 58, 1, N'/ProjectImages/Prescription/9/1-PDImage-9.png', N'/ProjectImages/Prescription/9/1-PrescriptionImage-9.png', CAST(N'2022-04-21T12:23:11.863' AS DateTime), 0, N'0.00', 0)
GO
SET IDENTITY_INSERT [dbo].[tblUserPrescription] OFF
GO
SET IDENTITY_INSERT [dbo].[tblVariation] ON 
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (1, 1, N'C3', N'#665D1E', N'#8C001A', N'Small', 110, 11, N'12', N'12', N'2', N'11', N'1', N'1', N'/ProjectImages/Variations/Callen-1.png', NULL, N'/ProjectImages/Variations/1857-GOLD54__LOKAHI_1857-O-GOLD54-46-22-145__2500x1400-Quarter.png', N'LK-116-C4')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (3, 1, N'ddff99', N'#8C001A', N'#665D1E', N'Medium', 115, 11, N'12', N'12', N'2', N'11', N'.5', N'.10', N'/ProjectImages/Variations/5.jpg', NULL, NULL, N'TY055-C4-2')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (6, 8, N'#00006', N'#665D1E', N'#665D1E', N'Medium', 115, 12, N'12', N'12', N'12', N'12', N'1', N'1', N'/ProjectImages/Variations/additional-right-img.png', NULL, N'/ProjectImages/Variations/Bilal_Saeed.jpg', NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (7, 9, N'00005', N'#665D1E', N'#665D1E', N'Small', 102, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/Capture.png', NULL, N'/ProjectImages/Variations/Bilal_Saeed.jpg', N'LK-116-C4')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (8, 10, N'00005', N'#665D1E', N'#665D1E', N'Small', 120, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (9, 11, N'00005', N'#665D1E', N'#665D1E', N'Small', 101, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (10, 12, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (11, 13, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (12, 14, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (13, 3, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, N'/ProjectImages/Variations/Cricket.jpg', N'321')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (14, 7, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (15, 17, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, NULL)
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (16, 18, N'00005', N'#665D1E', N'#665D1E', N'Small', 0, 0, N'12', N'12', N'12', N'12', N'12', N'12', N'/ProjectImages/Variations/additional-right-img.png', NULL, NULL, N'TY055-C4-2')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (17, 1, N'a', N'#000000', N'#000000', N'Small', 0, 0, N'ed', N'bc', N'12', N'21', N'12', N'12', N'/ProjectImages/Variations/1857-GOLD46__LOKAHI_1857-O-GOLD-46-22-145__2500x1400-Quarter.png', NULL, N'/ProjectImages/Variations/199964992_4060973250686974_7252579122980800100_n.jpg', N'TY055-C3')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (19, 9, N'00006', N'#665D1E', N'#000000', N'Small', 0, 0, N'12', N'13', N'14', N'67', N'1', N'2', N'/ProjectImages/Variations/placeholder.jpg', NULL, N'/ProjectImages/Variations/placeholder.jpg', N'123')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (20, 1, N'abc', N'#000000', N'#000000', N'Small', 12, 12, N'12', N'12', N'12', N'12', N'12', N'2112', N'/ProjectImages/Variations/2.png', NULL, N'/ProjectImages/Variations/Bilal_Saeed.jpg', N'12')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (22, 20, N'B2', N'#000000', N'#000000', N'Small', 50, 20, N'30', N'40', N'50', N'60', N'70', N'80', N'/ProjectImages/Variations/1.png', NULL, N'/ProjectImages/Variations/placeholder.jpg', N'TY055-C4-2')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (23, 22, N'BR1', N'#8C001A', N'#8C001A', N'Small', 135, 20, N'30', N'40', N'50', N'60', N'12', N'32', N'/ProjectImages/Variations/2.png', NULL, N'/ProjectImages/Variations/1.png', N'FDY95700-C2')
GO
INSERT [dbo].[tblVariation] ([VariationID], [ProductID], [ColorCode], [Color1], [Color2], [size], [FrameAWidth], [FrameBHeight], [FrameED], [FrameDBBridger], [FrameTempleLegs], [FrameTotalWidth], [MinPDPositive], [MinPDNeg], [ImagePath], [CreatedDate], [SideViewImagePath], [SKUNumber]) VALUES (24, 1, N'B2', N'#009B95', N'#000000', N'Small', 145, 500, N'300', N'200', N'500', N'100', N'30', N'200', N'/ProjectImages/Variations/additional-right-img.png', NULL, N'/ProjectImages/Variations/placeholder.jpg', N'LK-116-C4')
GO
SET IDENTITY_INSERT [dbo].[tblVariation] OFF
GO
SET IDENTITY_INSERT [dbo].[tblvariationimages] ON 
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (13, N'/ProjectImages/Variations/TR92196-C3__OLA_TR92196-O-C3-55-20-139__2500x1400-Front.png', 7, 9)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (14, N'/ProjectImages/Variations/Capture.png', 7, 9)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (24, N'/ProjectImages/Variations/additional-right-img.png', 22, 20)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (30, N'/ProjectImages/Variations/1.png', 22, 20)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (31, N'/ProjectImages/Variations/1.png', 23, 22)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (33, N'/ProjectImages/Variations/additional-right-img.png', 23, 22)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (34, N'/ProjectImages/Variations/2.png', 23, 22)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (43, N'/ProjectImages/Variations/1.png', 24, 1)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (44, N'/ProjectImages/Variations/2.png', 24, 1)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (45, N'/ProjectImages/Variations/additional-right-img.png', 24, 1)
GO
INSERT [dbo].[tblvariationimages] ([Variationimageid], [ImagePath], [VariationID], [ProductID]) VALUES (46, N'/ProjectImages/Variations/2.png', 20, 1)
GO
SET IDENTITY_INSERT [dbo].[tblvariationimages] OFF
GO
ALTER TABLE [dbo].[tblcart] ADD  CONSTRAINT [DF_tblcart_CouponID]  DEFAULT ((0)) FOR [CouponID]
GO
ALTER TABLE [dbo].[tblOrder] ADD  CONSTRAINT [DF_tblOrder_CouponID]  DEFAULT ((0)) FOR [CouponID]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Favourite_List]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_Get_Favourite_List] 
@Userid as int

as
Begin
			select F.FavouriteID as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,V.Color1 as ColorCode from tblProduct P
			inner join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = @Userid
			inner join tblVariation V  on V.ProductID = p.GlassID
			
			union all
			
			select F.FavouriteID as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,'' as ColorCode from tblProduct P
			inner join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = @Userid
			inner join tblglassPicture V  on V.glassID = p.GlassID  

End
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Five_Reviews]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_Get_Five_Reviews]
as
Begin
	select  top 5  p.Title, R.GlassID, U.UserImage,isnull(R.ReviewImage,'') as  ReviewImage,P.Price,R.Review,
	dbo.Get_Rating_Stats(P.GlassID,'TR') as TotalReviews,
	dbo.Get_Rating_Stats(P.GlassID,'AR') as AverageRating
	from tblReviews R
	inner join tblUser U on U.UserID = R.UserID
	inner join tblProduct P on P.GlassID = R.GlassID
	Where R.ReviewImage <> 'Null'
	order by R.CreatedDate desc
	
End
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Product_List]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_Get_Product_List] 
@Userid as int,
@Sticker as varchar(100)
as
Begin
	If (@Userid =0  AND @Sticker ='')
		Begin
			select case when F.ProductID is null then 0 Else 0  End as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,isnull(V.SideViewImagePath,'') as SideViewImagePath , 
			V.Color1 as ColorCode,V.SKUNumber, V.VariationID from tblProduct P
			Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = @Userid
			inner Join tblVariation V  on V.ProductID = p.GlassID 
			where P.ProductCategory<>'Accessory'
			order by P.GlassID
		End
	else If (@Userid !=0  AND @Sticker !='')
		Begin
			select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath, V.SideViewImagePath,V.Color1 as ColorCode,V.SKUNumber, V.VariationID 
			 from tblProduct P
			Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = @Userid 
			inner Join tblVariation V  on V.ProductID = p.GlassID 
			where P.Sticker = @Sticker and P.ProductCategory<>'Accessory'
			order by P.GlassID
		End
	else If (@Userid !=0  AND @Sticker ='')
		Begin
			select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,V.SideViewImagePath,V.Color1 as ColorCode,V.SKUNumber, V.VariationID  from tblProduct P
			Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = @Userid 
			inner Join tblVariation V  on V.ProductID = p.GlassID
			where P.ProductCategory<>'Accessory'
			order by P.GlassID 
		End
	else If (@Userid =0  AND @Sticker !='')
		Begin
			select case when F.ProductID is null then 0 Else 0  End as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,V.SideViewImagePath,V.Color1 as ColorCode,V.SKUNumber, V.VariationID  from tblProduct P
			Left Outer Join tblFavourite F  on F.ProductID = p.GlassID 
			inner Join tblVariation V  on V.ProductID = p.GlassID 

			where  P.Sticker = @Sticker
			and P.ProductCategory<>'Accessory'
			order by P.GlassID
		End

End


GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Product_List_Filter]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_Get_Product_List_Filter]
@ProductType as varchar(100),
@UserID as int,
@cwhere as varchar(2000)
as
	Begin
	Declare @csql as varchar(Max)=''
	

	if @ProductType ='Eyeglass' 
	begin
		set @csql = '
		select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		P.Sticker, P.GlassID, Title,Price,isnull(V.ImagePath,'''') as  ImagePath,
		isnull(V.SideViewImagePath,'''') as SideViewImagePath,
		isnull(V.Color1,'''')  as ColorCode, isnull(V.SKUNumber,'''') as  SKUNumber, V.VariationID from tblProduct P
		Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = '+cast(@UserID as varchar(50))+'
		inner Join tblVariation V  on V.ProductID = p.GlassID
		inner join tblColors C on c.hexacode = V.Color1 
		where P.GlassID > 0 	
		and  P.ProductCategory<>''Accessory'' and  P.ProductCategory ='''+@ProductType+'''
		'+@cwhere+'	order by P.GlassID '
	end
	else if @ProductType ='Sunglass' 
	begin
		set @csql = '
		select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		P.Sticker, P.GlassID, Title,Price,isnull(V.ImagePath,'''') as  ImagePath,
		isnull(V.SideViewImagePath,'''') as SideViewImagePath,
		isnull(V.Color1,'''')  as ColorCode, isnull(V.SKUNumber,'''') as  SKUNumber, V.VariationID from tblProduct P
		Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = '+cast(@UserID as varchar(50))+'
		inner Join tblVariation V  on V.ProductID = p.GlassID 
		inner join tblColors C on c.hexacode = V.Color1
		where P.GlassID > 0 	
		and  P.ProductCategory<>''Accessory'' and  P.ProductCategory ='''+@ProductType+'''
		'+@cwhere+'	order by P.GlassID '
	end
	else if @ProductType<>'Accessory' 
	begin
		set @csql = '
		select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		P.Sticker, P.GlassID, Title,Price,isnull(V.ImagePath,'''') as  ImagePath,
		isnull(V.SideViewImagePath,'''') as SideViewImagePath,
		isnull(V.Color1,'''')  as ColorCode, isnull(V.SKUNumber,'''') as  SKUNumber, V.VariationID from tblProduct P
		Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = '+cast(@UserID as varchar(50))+'
		inner Join tblVariation V  on V.ProductID = p.GlassID 
		inner join tblColors C on c.hexacode = V.Color1
		where P.GlassID > 0 	
		and  P.ProductCategory<>''Accessory''
		'+@cwhere+'	order by P.GlassID '
	end
	else if @ProductType='Accessory'
	begin
		set @csql = '
		select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		P.Sticker, P.GlassID, Title,Price,isnull(V.ImagePath,'''') as ImagePath,'''' as  SideViewImagePath, '''' as ColorCode
		, '''' as  SKUNumber, 0 as VariationID
		 from tblProduct P
		Left Outer Join tblFavourite F  on F.ProductID = p.GlassID and F.UserID = '+cast(@UserID as varchar(50))+'
		Left Outer Join tblglassPicture V  on V.glassID = p.GlassID 
		where P.GlassID > 0  '+@cwhere+' order by P.GlassID	'
	end


	exec (@csql)
	print (@csql)

	End
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Product_List_Filter_Accessory]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_Get_Product_List_Filter_Accessory]
--@ProductType as varchar(100),
--@ProductFilter as varchar(100)
@cwhere as varchar(2000)
as
	Begin
	Declare @csql as varchar(Max)=''
		--select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		--P.Sticker, P.GlassID, Title,Price,V.ImagePath from tblProduct P
		--Left Outer Join tblFavourite F  on F.ProductID = p.GlassID --and F.UserID = 1
		--Left Outer Join tblglassPicture V  on V.glassID = p.GlassID 
		--where P.GlassID > 0 and ProductCategory='Accessory'
	set @csql = '
		select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		P.Sticker, P.GlassID, Title,Price,V.ImagePath from tblProduct P
		Left Outer Join tblFavourite F  on F.ProductID = p.GlassID --and F.UserID = 1
		Left Outer Join tblglassPicture V  on V.glassID = p.GlassID 
		where P.GlassID > 0 	
		
'+@cwhere+'	'

	exec (@csql)
--	print (@csql)

		--if @Producttype='Gender'
		--	Begin
		--		if @ProductFilter <>'' and @ProductFilter <>'0'
		--			Begin
						
		--				select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		--				P.Sticker, P.GlassID, Title,Price,V.ImagePath,V.ColorCode from tblProduct P
		--				Left Outer Join tblFavourite F  on F.ProductID = p.GlassID --and F.UserID = 1
		--				Left Outer Join tblVariation V  on V.ProductID = p.GlassID 
		--				where Gender=@ProductFilter 
		--				and ProductCategory <> 'Accessory'
		--				order by P.GlassID
		--			End
		--		else 
		--			Begin
		--			select case when F.ProductID is null then 0 Else 1  End as Likestatus ,
		--				P.Sticker, P.GlassID, Title,Price,V.ImagePath,V.ColorCode from tblProduct P
		--				Left Outer Join tblFavourite F  on F.ProductID = p.GlassID --and F.UserID = 1
		--				Left Outer Join tblVariation V  on V.ProductID = p.GlassID 
		--				where  ProductCategory <> 'Accessory'
		--				order by P.GlassID
		--				--select * from tblProduct where  ProductCategory <> 'Accessory'
		--			End				
		--		---i Join tblVariation V  on V.ProductID = p.GlassID 
		--	End
		--else if @Producttype='Shape'
		--	Begin
		--		select * from tblProduct where shape=@ProductFilter
		--		and ProductCategory <> 'Accessory'
		--	End
		----else if @Producttype='Color'
		----	Begin
		----		select * from tblProduct where colour=@ProductFilter
		----	End
		--else if @Producttype='Material'
		--	Begin
		--		select * from tblProduct where Material=@ProductFilter
		--		and ProductCategory <> 'Accessory'
		--	End
		--else if @Producttype='Size'
		--	Begin
		--		select * from tblProduct where AvailableSize=@ProductFilter
		--		and ProductCategory <> 'Accessory'
		--	End
		--else
		--	Begin
		--		select * from tblProduct
		--		where ProductCategory <> 'Accessory'
		--	End
	End
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Product_VirtualTry_List]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_Get_Product_VirtualTry_List] 
@ProductId as int
as
Begin
	If @ProductId>0
		Begin
			select distinct  case when F.ProductID is null then 0 Else 0  End as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,isnull(V.SideViewImagePath,'') as SideViewImagePath , V.Color1 as ColorCode,V.SKUNumber from tblProduct P
			Left Outer Join tblFavourite F  on F.ProductID = p.GlassID 
			inner Join tblVariation V  on V.ProductID = p.GlassID 
			where P.GlassID =@ProductId
			order by P.GlassID
		End
	else If @ProductId =0
		Begin
			select  distinct case when F.ProductID is null then 0 Else 0  End as Likestatus ,
			P.Sticker, P.GlassID, Title,Price,V.ImagePath,isnull(V.SideViewImagePath,'') as SideViewImagePath , V.Color1 as ColorCode,V.SKUNumber from tblProduct P
			Left Outer Join tblFavourite F  on F.ProductID = p.GlassID 
			inner Join tblVariation V  on V.ProductID = p.GlassID 
			order by P.GlassID
		End
	

End


GO
/****** Object:  StoredProcedure [dbo].[spgetorderDetails]    Script Date: 4/29/2022 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spgetorderDetails]

@OrderID as int
AS
begin
SELECT        O.OrderID, O.userID, O.UserName, O.UserEmail, O.Status, O.IsPaid, O.Total as TotalAmount,  O.OrderComments, O.OrderDate, O.UserAddress, D.OrderDetailID,  D.ProductID, D.Productname, 
D.ProductPrice, O.BFname, O.BLname, O.BAddress, O.BCity, O.BState, O.BPostalCode, o.BPhone, o.BEmail, o.BCountry,
O.SFname, O.SLname, O.SAddress, O.SCity, O.SState, O.SPostalCode, o.SPhone, o.SEmail, o.SCountry,  D.Vision , D.LensType , D.UV_Protection, 
D.Total As ProductTotal, D.ProductVariation, D.quantity, D.TaxAmount, D.Discount, C.colorname as FrameColor, D.ProductImage, D.ShippingAmount, D.Subtotal, P.PrescriptionID,  P.r_sph, P.r_cyl, P.r_axis, 
P.r_add, P.l_sph, P.l_cyl, P.l_axis, P.l_add, P.prescription, P.prescriptionDate, P.PD,  P.PDImage, P.PrescriptionImage, 
P.CreatedDate
FROM            tblOrder AS O INNER JOIN
tblOrderDetails AS D ON O.OrderID = D.OrderID LEFT OUTER JOIN
tblOrderPrescription AS P ON P.OrderID = O.OrderID
Left outer  join tblColors C on C.hexacode=D.FrameColor

where O.OrderID=@OrderID
end
GO
