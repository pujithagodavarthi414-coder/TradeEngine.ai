using System;
using System.Collections.Generic;
using System.Text;
using AutoFixture;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Services.Fake;
using DocumentStorageService.Repositories.Fake;
using Microsoft.Extensions.Configuration;
using NUnit.Framework;

namespace DocumentStorageService.Tests.FileStore
{
    [TestFixture]
    public class FileStoreApiTests
    {
        IConfiguration iconfiguration;
        private readonly Fixture _fixture = new Fixture();

        [Test]
        public void CreateFolder_OnSuccess_Should_Return_NewId()
        {
            UpsertFolderInputModel folderInputModel = this.GetFolderData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileService fileService = this.GetInstance();
            // Act

            var result = fileService.UpsertFolder(folderInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596"), new Guid(result.ToString()));

        }

        [Test]
        public void UpdateFolder_OnSuccess_Should_Return_ChannelId()
        {
            UpsertFolderInputModel folderInputModel = this.GetUpdateFolderData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileService fileService = this.GetInstance();
            // Act

            var result = fileService.UpsertFolder(folderInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596"), new Guid(result.ToString()));

        }

        [Test]
        public void ArchiveFolder_OnSuccess_Should_Return_True()
        {
            IFakeFileService fileService = this.GetInstance();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            //Arrange
            Guid folderId = Guid.NewGuid();

            //Act
            var result = fileService.DeleteFolder(folderId, loggedInContext, new List<ValidationMessage>());

            //Assert
            Assert.AreEqual(true, result);
        }

        private UpsertFolderInputModel GetFolderData()
        {
            var result = this._fixture.Create<UpsertFolderInputModel>();
            result.FolderId = null;
            result.FolderName = "Test folder";
            result.FolderReferenceId = new Guid("6F8E8A6D-EDE3-4D6A-9A8B-32DA09F4F76F");
            result.FolderReferenceTypeId = new Guid("A40F3109-F880-4214-9367-4D5E86864649");
            result.StoreId = new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3");
            result.ParentFolderId = new Guid("E60B611C-424D-47EC-B555-E31120C52D89");
            result.Description = "Test description";
            result.Size = null;
            result.IsArchived = null;
            return result;
        }

        private UpsertFolderInputModel GetUpdateFolderData()
        {
            var result = this._fixture.Create<UpsertFolderInputModel>();
            result.FolderId = new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596");
            result.FolderName = "Test folder";
            result.FolderReferenceId = new Guid("6F8E8A6D-EDE3-4D6A-9A8B-32DA09F4F76F");
            result.FolderReferenceTypeId = new Guid("A40F3109-F880-4214-9367-4D5E86864649");
            result.StoreId = new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3");
            result.ParentFolderId = new Guid("E60B611C-424D-47EC-B555-E31120C52D89");
            result.Description = "Test description data";
            result.Size = null;
            return result;
        }

        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this._fixture.Create<LoggedInContext>();
            return loggedInContext;
        }

        private IFakeFileService GetInstance()
        {
            return new FakeFileService(new FakeFileRepository());
        }

        [TestCase(null, null, null, null, null, null)]
        [TestCase("testForm", "E60B611C-424D-47EC-B555-E31120C52D89", "6F8E8A6D-EDE3-4D6A-9A8B-32DA09F4F76F", "A40F3109-F880-4214-9367-4D5E86864649", "2EE26168-6F94-4CF1-9385-FDF084BD91F3", null)]
        [TestCase("testFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestForm", "47ECA7AF-FD8D-4848-AB0E-4BA9D86F05C9", "6F8E8A6D-EDE3-4D6A-9A8B-32DA09F4F76F", "A40F3109-F880-4214-9367-4D5E86864649", "2EE26168-6F94-4CF1-9385-FDF084BD91F3", null)]
        public void UpsertFolder_UnSuccessfullyCreated_ShouldReturnNULL(string folderName, string parentfolderId,
            string folderReferenceId, string folderReferenceTypeId, string storeId, string description)
        {
            // Arrange
            UpsertFolderInputModel folderInputModel = this.GetFolderData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileService fakeFileServiceService = this.GetInstance();
            folderInputModel.FolderName = folderName;
            folderInputModel.ParentFolderId = new Guid(parentfolderId);
            folderInputModel.StoreId = new Guid(storeId);
            folderInputModel.FolderReferenceId = new Guid(folderReferenceId);
            folderInputModel.FolderReferenceTypeId = new Guid(folderReferenceTypeId);
            // Act

            var result = fakeFileServiceService.UpsertFolder(folderInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase("testFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestForm", "3B3DE008-7F82-4ADF-A867-8827A99CE596")]

        public void UpdateFolder_UnSuccessfullyCreated_ShouldReturnNull(string folderName, string folderId)
        {
            // Arrange
            UpsertFolderInputModel folderInputModel = this.GetFolderData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileService fakeFileServiceService = this.GetInstance();
            folderInputModel.FolderName = folderName;
            folderInputModel.FolderId = Guid.Parse(folderId);
            // Act

            var result = fakeFileServiceService.UpdateFolder(folderInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase("testFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestFormtestForm", "3B3DE008-7F82-4ADF-A867-8827A99CE596")]

        public void UpdateFolderDescription_UnSuccessfullyCreated_ShouldReturnNull(string folderName, string folderId)
        {
            // Arrange
            UpsertFolderInputModel folderInputModel = this.GetFolderData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            IFakeFileService fakeFileServiceService = this.GetInstance();
            folderInputModel.FolderName = folderName;
            folderInputModel.FolderId = Guid.Parse(folderId);
            // Act

            var result = fakeFileServiceService.UpdateFolderDescription(folderInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

    }
}
