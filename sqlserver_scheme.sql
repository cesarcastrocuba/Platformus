--
-- Extension: Platformus.Configurations
-- Version: beta1
--
CREATE TABLE [dbo].[Configurations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	CONSTRAINT [PK_Configurations] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Configurations_Code] ON [dbo].[Configurations] ([Code] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[Variables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConfigurationId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Variables] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Variables_ConfigurationId] ON [dbo].[Variables]([ConfigurationId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Variables_ConfigurationId_Code] ON [dbo].[Variables] ([ConfigurationId] ASC, [Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Variables] WITH CHECK ADD CONSTRAINT [FK_Variables_Configurations] FOREIGN KEY ([ConfigurationId]) REFERENCES [dbo].[Configurations] ([Id]);

--
-- Extension: Platformus.Security
-- Version: beta1
--
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Created] [datetime] NOT NULL,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Users_Name] ON [dbo].[Users] ([Name] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[CredentialTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_CredentialTypes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_CredentialTypes_Code] ON [dbo].[CredentialTypes] ([Code] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[Credentials](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[CredentialTypeId] [int] NOT NULL,
	[Identifier] [nvarchar](64) NOT NULL,
	[Secret] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Credentials_UserId] ON [dbo].[Credentials] ([UserId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Credentials] WITH CHECK ADD CONSTRAINT [FK_Credentials_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]);
ALTER TABLE [dbo].[Credentials] WITH CHECK ADD CONSTRAINT [FK_Credentials_CredentialTypes] FOREIGN KEY ([CredentialTypeId]) REFERENCES [dbo].[CredentialTypes] ([Id]);

CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Roles_Code] ON [dbo].[Roles] ([Code] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[UserRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
	CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[UserRoles] WITH CHECK ADD CONSTRAINT [FK_UserRoles_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]);
ALTER TABLE [dbo].[UserRoles] WITH CHECK ADD CONSTRAINT [FK_UserRoles_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]);

CREATE TABLE [dbo].[Permissions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Permissions_Code] ON [dbo].[Permissions] ([Code] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[RolePermissions](
	[RoleId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
	CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED ([RoleId] ASC, [PermissionId] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[RolePermissions] WITH CHECK ADD CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]);
ALTER TABLE [dbo].[RolePermissions] WITH CHECK ADD CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[Permissions] ([Id]);

--
-- Extension: Platformus.FileManager
-- Version: beta1
--
CREATE TABLE [dbo].[Files](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Size] [bigint] NOT NULL,
	CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

--
-- Extension: Platformus.Globalization
-- Version: beta1
--
CREATE TABLE [dbo].[Cultures](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[IsNeutral] [bit] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsBackendUi] [bit] NOT NULL,
	CONSTRAINT [PK_Cultures] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Cultures_Code] ON [dbo].[Cultures] ([Code] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[Dictionaries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	CONSTRAINT [PK_Dictionaries] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[Localizations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DictionaryId] [int] NOT NULL,
	[CultureId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
	CONSTRAINT [PK_Localizations] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Localizations_DictionaryId] ON [dbo].[Localizations] ([DictionaryId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Localizations_DictionaryId_CultureId] ON [dbo].[Localizations] ([CultureId] ASC, [DictionaryId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Localizations] WITH CHECK ADD CONSTRAINT [FK_Localizations_Dictionaries] FOREIGN KEY ([DictionaryId]) REFERENCES [dbo].[Dictionaries] ([Id]);
ALTER TABLE [dbo].[Localizations] WITH CHECK ADD CONSTRAINT [FK_Localizations_Cultures] FOREIGN KEY ([CultureId]) REFERENCES [dbo].[Cultures] ([Id]);

--
-- Extension: Platformus.Routing
-- Version: beta1
--
CREATE TABLE [dbo].[Endpoints](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[UrlTemplate] [nvarchar](128) NULL,
	[Position] [int] NULL,
	[DisallowAnonymous] [bit] NOT NULL,
	[SignInUrl] [nvarchar](128),
	[CSharpClassName] [nvarchar](128) NOT NULL,
	[Parameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Endpoints] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[EndpointPermissions](
	[EndpointId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
	CONSTRAINT [PK_EndpointPermissions] PRIMARY KEY CLUSTERED ([EndpointId] ASC, [PermissionId] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[EndpointPermissions] WITH CHECK ADD CONSTRAINT [FK_EndpointPermissions_Roles] FOREIGN KEY ([EndpointId]) REFERENCES [dbo].[Endpoints] ([Id]);
ALTER TABLE [dbo].[EndpointPermissions] WITH CHECK ADD CONSTRAINT [FK_EndpointPermissions_Permissions] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[Permissions] ([Id]);

CREATE TABLE [dbo].[DataSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EndpointId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[CSharpClassName] [nvarchar](128) NOT NULL,
	[Parameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_DataSources] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_DataSources_EndpointId] ON [dbo].[DataSources] ([EndpointId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[DataSources] WITH CHECK ADD CONSTRAINT [FK_DataSources_Endpoints] FOREIGN KEY ([EndpointId]) REFERENCES [dbo].[Endpoints] ([Id]);

--
-- Extension: Platformus.Domain
-- Version: beta1
--
CREATE TABLE [dbo].[Classes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[PluralizedName] [nvarchar](64) NOT NULL,
	[IsAbstract] [bit] NOT NULL,
	CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[Classes] WITH CHECK ADD CONSTRAINT [FK_Classes_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

CREATE TABLE [dbo].[Tabs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_Tabs] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Tabs_ClassId] ON [dbo].[Tabs] ([ClassId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Tabs] WITH CHECK ADD CONSTRAINT [FK_Tabs_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

CREATE TABLE [dbo].[DataTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StorageDataType] [nvarchar](32) NOT NULL,
	[JavaScriptEditorClassName] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_DataTypes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[DataTypeParameters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeId] [int] NOT NULL,
	[JavaScriptEditorClassName] [nvarchar](128) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	CONSTRAINT [PK_DataTypeParameters] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_DataTypeParameters_DataTypeId] ON [dbo].[DataTypeParameters] ([DataTypeId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[DataTypeParameters] WITH CHECK ADD CONSTRAINT [FK_DataTypeParameters_DataTypes_DataTypeId] FOREIGN KEY ([DataTypeId]) REFERENCES [dbo].[DataTypes] ([Id]);

CREATE TABLE [dbo].[Members](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	[TabId] [int] NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	[PropertyDataTypeId] [int] NULL,
	[IsPropertyLocalizable] [bit] NULL,
	[IsPropertyVisibleInList] [bit] NULL,
	[RelationClassId] [int] NULL,
	[IsRelationSingleParent] [bit] NULL,
	[MinRelatedObjectsNumber] [int] NULL,
	[MaxRelatedObjectsNumber] [int] NULL,
	CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Members_ClassId] ON [dbo].[Members] ([ClassId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_Classes_ClassId] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_Tabs] FOREIGN KEY ([TabId]) REFERENCES [dbo].[Tabs] ([Id]);
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_DataTypes] FOREIGN KEY ([PropertyDataTypeId]) REFERENCES [dbo].[DataTypes] ([Id]);
ALTER TABLE [dbo].[Members] WITH CHECK ADD CONSTRAINT [FK_Members_Classes_RelationClassId] FOREIGN KEY ([RelationClassId]) REFERENCES [dbo].[Classes] ([Id]);

CREATE TABLE [dbo].[DataTypeParameterValues](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeParameterId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	CONSTRAINT [PK_DataTypeParameterValues] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_DataTypeParameterValues_DataTypeParameterId] ON [dbo].[DataTypeParameterValues] ([DataTypeParameterId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[DataTypeParameterValues] WITH CHECK ADD CONSTRAINT [FK_DataTypeParameterValues_DataTypeParameters_DataTypeParameterId] FOREIGN KEY ([DataTypeParameterId]) REFERENCES [dbo].[DataTypeParameters] ([Id]);
ALTER TABLE [dbo].[DataTypeParameterValues] WITH CHECK ADD CONSTRAINT [FK_DataTypeParameterValues_Members_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Members] ([Id]);

CREATE TABLE [dbo].[Objects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Objects_ClassId] ON [dbo].[Objects] ([ClassId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Objects] WITH CHECK ADD CONSTRAINT [FK_Objects_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

CREATE TABLE [dbo].[Properties](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ObjectId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[IntegerValue] [int] NULL,
	[DecimalValue] [money] NULL,
	[StringValueId] [int] NULL,
	[DateTimeValue] [datetime] NULL,
	CONSTRAINT [PK_Properties] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Properties_ObjectId] ON [dbo].[Properties] ([ObjectId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Properties_ObjectId_MemberId] ON [dbo].[Properties] ([ObjectId] ASC, [MemberId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Properties] WITH CHECK ADD CONSTRAINT [FK_Properties_Objects] FOREIGN KEY ([ObjectId]) REFERENCES [dbo].[Objects] ([Id]);
ALTER TABLE [dbo].[Properties] WITH CHECK ADD CONSTRAINT [FK_Properties_Members] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Members] ([Id]);
ALTER TABLE [dbo].[Properties] WITH CHECK ADD CONSTRAINT [FK_Properties_Dictionaries] FOREIGN KEY ([StringValueId]) REFERENCES [dbo].[Dictionaries] ([Id]);

CREATE TABLE [dbo].[Relations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[PrimaryId] [int] NOT NULL,
	[ForeignId] [int] NOT NULL,
	CONSTRAINT [PK_Relations] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Relations_PrimaryId] ON [dbo].[Relations] ([PrimaryId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Relations_MemberId_PrimaryId] ON [dbo].[Relations] ([PrimaryId] ASC, [MemberId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Relations_ForeignId] ON [dbo].[Relations] ([ForeignId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_Relations_MemberId_ForeignId] ON [dbo].[Relations] ([MemberId] ASC, [ForeignId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Relations] WITH CHECK ADD CONSTRAINT [FK_Relations_Members] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Members] ([Id]);
ALTER TABLE [dbo].[Relations] WITH CHECK ADD CONSTRAINT [FK_Relations_Objects_PrimaryId] FOREIGN KEY ([PrimaryId]) REFERENCES [dbo].[Objects] ([Id]);
ALTER TABLE [dbo].[Relations] WITH CHECK ADD CONSTRAINT [FK_Relations_Objects_ForeignId] FOREIGN KEY ([ForeignId]) REFERENCES [dbo].[Objects] ([Id]);

CREATE TABLE [dbo].[SerializedObjects](
	[CultureId] [int] NOT NULL,
	[ObjectId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[UrlPropertyStringValue] [nvarchar](128) NULL,
	[SerializedProperties] [nvarchar](max) NULL,
	CONSTRAINT [PK_SerializedObjects] PRIMARY KEY CLUSTERED ([CultureId] ASC, [ObjectId] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_SerializedObjects_UrlPropertyStringValue] ON [dbo].[SerializedObjects] ([UrlPropertyStringValue] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[SerializedObjects] WITH CHECK ADD CONSTRAINT [FK_SerializedObjects_Cultures] FOREIGN KEY ([CultureId]) REFERENCES [dbo].[Cultures] ([Id]);
ALTER TABLE [dbo].[SerializedObjects] WITH CHECK ADD CONSTRAINT [FK_SerializedObjects_Objects] FOREIGN KEY ([ObjectId]) REFERENCES [dbo].[Objects] ([Id]);
ALTER TABLE [dbo].[SerializedObjects] WITH CHECK ADD CONSTRAINT [FK_SerializedObjects_Classes] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[Classes] ([Id]);

--
-- Extension: Platformus.Menus
-- Version: beta1
--
CREATE TABLE [dbo].[Menus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Menus_Code] ON [dbo].[Menus] ([Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Menus] WITH CHECK ADD CONSTRAINT [FK_Menus_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

CREATE TABLE [dbo].[MenuItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId] [int] NULL,
	[MenuItemId] [int] NULL,
	[NameId] [int] NOT NULL,
	[Url] [nvarchar](128) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_MenuItems] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_MenuItems_MenuId] ON [dbo].[MenuItems] ([MenuId] ASC) ON [PRIMARY];
CREATE NONCLUSTERED INDEX [IX_MenuItems_MenuItemId] ON [dbo].[MenuItems] ([MenuItemId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_Menus] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[Menus] ([Id]);
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_MenuItems] FOREIGN KEY ([MenuItemId]) REFERENCES [dbo].[MenuItems] ([Id]);
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

CREATE TABLE [dbo].[SerializedMenus](
	[CultureId] [int] NOT NULL,
	[MenuId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[SerializedMenuItems] [nvarchar](max) NULL,
	CONSTRAINT [PK_SerializedMenus] PRIMARY KEY CLUSTERED ([CultureId] ASC, [MenuId] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_SerializedMenus_Code] ON [dbo].[SerializedMenus] ([Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[SerializedMenus] WITH CHECK ADD CONSTRAINT [FK_SerializedMenus_Cultures] FOREIGN KEY ([CultureId]) REFERENCES [dbo].[Cultures] ([Id]);
ALTER TABLE [dbo].[SerializedMenus] WITH CHECK ADD CONSTRAINT [FK_SerializedMenus_Menus] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[Menus] ([Id]);

--
-- Extension: Platformus.Forms
-- Version: beta1
--
CREATE TABLE [dbo].[Forms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[ProduceCompletedForms] [bit] NOT NULL,
	[CSharpClassName] [nvarchar](128) NOT NULL,
	[Parameters] [nvarchar](1024) NULL,
	CONSTRAINT [PK_Forms] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Forms_Code] ON [dbo].[Forms] ([Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Forms] WITH CHECK ADD CONSTRAINT [FK_Forms_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

CREATE TABLE [dbo].[FieldTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_FieldTypes] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_FieldTypes_Code] ON [dbo].[FieldTypes] ([Code] ASC) ON [PRIMARY];

CREATE TABLE [dbo].[Fields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NOT NULL,
	[FieldTypeId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[NameId] [int] NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[MaxLength] [int],
	[Position] [int] NULL,
	CONSTRAINT [PK_Fields] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_Fields_FieldId] ON [dbo].[Fields] ([FormId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[Fields] WITH CHECK ADD CONSTRAINT [FK_Fields_Forms] FOREIGN KEY ([FormId]) REFERENCES [dbo].[Forms] ([Id]);
ALTER TABLE [dbo].[Fields] WITH CHECK ADD CONSTRAINT [FK_Fields_FieldTypes] FOREIGN KEY ([FieldTypeId]) REFERENCES [dbo].[FieldTypes] ([Id]);
ALTER TABLE [dbo].[Fields] WITH CHECK ADD CONSTRAINT [FK_Fields_Dictionaries] FOREIGN KEY ([NameId]) REFERENCES [dbo].[Dictionaries] ([Id]);

CREATE TABLE [dbo].[FieldOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FieldId] [int] NOT NULL,
	[ValueId] [int] NOT NULL,
	[Position] [int] NULL,
	CONSTRAINT [PK_FieldOptions] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_FieldOptions_FieldId] ON [dbo].[FieldOptions] ([FieldId] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[FieldOptions] WITH CHECK ADD CONSTRAINT [FK_FieldOptions_Fields] FOREIGN KEY ([FieldId]) REFERENCES [dbo].[Fields] ([Id]);
ALTER TABLE [dbo].[FieldOptions] WITH CHECK ADD CONSTRAINT [FK_FieldOptions_Dictionaries] FOREIGN KEY ([ValueId]) REFERENCES [dbo].[Dictionaries] ([Id]);

CREATE TABLE [dbo].[CompletedForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	CONSTRAINT [PK_CompletedForms] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[CompletedForms] WITH CHECK ADD CONSTRAINT [FK_CompletedForms_Forms] FOREIGN KEY ([FormId]) REFERENCES [dbo].[Forms] ([Id]);

CREATE TABLE [dbo].[CompletedFields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompletedFormId] [int] NOT NULL,
	[FieldId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
	CONSTRAINT [PK_CompletedFields] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

ALTER TABLE [dbo].[CompletedFields] WITH CHECK ADD CONSTRAINT [FK_CompletedFields_CompletedForms] FOREIGN KEY ([CompletedFormId]) REFERENCES [dbo].[CompletedForms] ([Id]);
ALTER TABLE [dbo].[CompletedFields] WITH CHECK ADD CONSTRAINT [FK_CompletedFields_Fields] FOREIGN KEY ([FieldId]) REFERENCES [dbo].[Fields] ([Id]);

CREATE TABLE [dbo].[SerializedForms](
	[CultureId] [int] NOT NULL,
	[FormId] [int] NOT NULL,
	[Code] [nvarchar](32) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[SerializedFields] [nvarchar](max) NULL,
	CONSTRAINT [PK_SerializedForms] PRIMARY KEY CLUSTERED ([CultureId] ASC, [FormId] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_SerializedForms_Code] ON [dbo].[SerializedForms] ([Code] ASC) ON [PRIMARY];
ALTER TABLE [dbo].[SerializedForms] WITH CHECK ADD CONSTRAINT [FK_SerializedForms_Cultures] FOREIGN KEY ([CultureId]) REFERENCES [dbo].[Cultures] ([Id]);
ALTER TABLE [dbo].[SerializedForms] WITH CHECK ADD CONSTRAINT [FK_SerializedForms_Forms] FOREIGN KEY ([FormId]) REFERENCES [dbo].[Forms] ([Id]);