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
using Newtonsoft.Json;
namespace DocumentStorageService.Tests.FileStore
{
    [TestFixture]
    public class FileApiTests
    {
        IConfiguration iconfiguration;
        private readonly Fixture _fixture = new Fixture();

        [Test]
        public void CreateFile_OnSuccess_Should_Return_NewId()
        {
            UpsertFileInputModel fileInputModel = this.GetFileData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act

            var result = fileUploadService.CreateMultipleFiles(fileInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD"), new Guid(result.ToString()));

        }
        [Test]
        public void UpdateFile_OnSuccess_Should_Return_FileId()
        {
            FileModel fileInputModel = this.GetUpdateFileData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act

            var result = fileUploadService.UpdateFile(fileInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD"), new Guid(result.ToString()));

        }

        [Test]
        public void ReviewFile_OnSuccess_Should_Return_FileId()
        {
            FileModel fileInputModel = this.GetUpdateFileData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act

            var result = fileUploadService.ReviewFile(fileInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD"), new Guid(result.ToString()));

        }

        [Test]
        public void ArchiveFile_OnSuccess_Should_Return_True()
        {
            IFakeFileUploadService fileUploadService = this.GetInstance();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            //Arrange
            Guid fileId = Guid.NewGuid();

            //Act
            var result = fileUploadService.DeleteFile(fileId, loggedInContext, new List<ValidationMessage>());

            //Assert
            Assert.AreEqual(true, result);
        }

        [Test]
        public void SearchFile_SuccessfullyReturn()
        {
            // Arrange
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            FileSearchCriteriaInputModel fileSearchCriteriaInput = new FileSearchCriteriaInputModel();
            fileSearchCriteriaInput.IsArchived = false;
            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act

            var result = fileUploadService.SearchFile(fileSearchCriteriaInput, loggedInContext, new List<ValidationMessage>());
            var expectedResult = SearchFileData();
            // Assert
            AreEqualByObject(expectedResult, result);
        }

        [Test]
        public void SearchFile_UnSuccessfullyReturn()
        {
            // Arrange
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            FileSearchCriteriaInputModel fileSearchCriteriaInput = new FileSearchCriteriaInputModel();
            fileSearchCriteriaInput.IsArchived = false;
            IFakeFileUploadService fileUploadService = this.GetInstance();
            var validationMessages = new List<ValidationMessage>();
            // Act

            var result = fileUploadService.SearchFile(fileSearchCriteriaInput, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        [TestCase(false, null, null)]
        [TestCase(false, null, "d3c3f943-e134-47d4-afca-5dc0b5eb1c6")]
        [TestCase(false, "92A1FF92-1158-4B64-8ABF-BD815337FBFD", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6")]
        [TestCase(false, "92A1FF92-1158-4B64-8ABF-BD815337FBFD", null)]
        public void SearchFile_SuccessfullyReturn(bool isArchived, string id, string folderId)
        {
            // Arrange
            FileSearchCriteriaInputModel fileSearchCriteriaInput = new FileSearchCriteriaInputModel();
            fileSearchCriteriaInput.IsArchived = isArchived;
            fileSearchCriteriaInput.FileId = new Guid(id);
            fileSearchCriteriaInput.FolderId = new Guid(folderId);
            fileSearchCriteriaInput.ReferenceId = new Guid(folderId);
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act

            var result = fileUploadService.SearchFile(fileSearchCriteriaInput, loggedInContext, new List<ValidationMessage>());
            var expectedResult = SearchFileOutput();
            // Assert
            AreEqualByObject(expectedResult, result);
        }

        public List<FileApiReturnModel> SearchFileOutput()
        {
            return new List<FileApiReturnModel>
            {
                new FileApiReturnModel
                {
                    Id = new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD"),
                    FolderId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b"),
                    ReferenceId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b"),
                    ReferenceTypeId = new Guid("1b35f2d3-1972-491f-8dc8-0a2a1f429934"),
                    FileName = "Actvity-Log.xlsx",
                    FileSize = 7676,
                    FilePath = "https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx",
                    FileExtension = ".xlsx",
                    IsArchived = false
                }
            };
        }
        [TestCase(null, null, "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        public void SearchFile_UnSuccessfullyReturn(bool? isArchived, string id, string folderId)
        {
            // Arrange
            FileSearchCriteriaInputModel fileSearchCriteriaInput = new FileSearchCriteriaInputModel();
            fileSearchCriteriaInput.IsArchived = isArchived;
            fileSearchCriteriaInput.FileId = new Guid(id);
            fileSearchCriteriaInput.FolderId = new Guid(folderId);
            fileSearchCriteriaInput.ReferenceId = new Guid(folderId);
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            var validationMessages = new List<ValidationMessage>();
            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act

            var result = fileUploadService.SearchFile(fileSearchCriteriaInput, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }
        public List<FileApiReturnModel> SearchFileData()
        {
            return new List<FileApiReturnModel>
            {
                new FileApiReturnModel
                {
                    Id = new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD"),
                    FolderId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b"),
                    ReferenceId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b"),
                    ReferenceTypeId = new Guid("1b35f2d3-1972-491f-8dc8-0a2a1f429934"),
                    FileName = "Actvity-Log.xlsx",
                    FileSize = 7676,
                    FilePath = "https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx",
                    FileExtension = ".xlsx",
                    IsArchived = false
                }
            };
        }

        public static void AreEqualByObject(List<FileApiReturnModel> expected, List<FileApiReturnModel> actual)
        {
            var expectedJson = JsonConvert.SerializeObject(expected);
            var actualJson = JsonConvert.SerializeObject(actual);
            Assert.AreEqual(expectedJson, actualJson);
        }

        private UpsertFileInputModel GetFileData()
        {
            var result = this._fixture.Create<UpsertFileInputModel>();
            result.FolderId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b");
            result.ReferenceTypeId = new Guid("1b35f2d3-1972-491f-8dc8-0a2a1f429934");
            result.ReferenceId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b");
            result.StoreId = new Guid("d64b3144-41f7-4fd2-9bb9-3083aaf00c5f");
            var fileModel = new FileModel();
            fileModel.FilePath = "https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx";
            fileModel.FileExtension = ".xlsx";
            fileModel.FileSize = 7676;
            fileModel.FileName = "Actvity-Log.xlsx";
            result.FilesList.Add(fileModel);
            result.IsArchived = false;
            var parentFolderNames = "";
            result.ParentFolderNames.Add(parentFolderNames);
            return result;
        }

        private FileModel GetUpdateFileData()
        {
            var fileModel = this._fixture.Create<FileModel>();
            fileModel.FileName = "Activity-Log.xlsx";
            fileModel.FileId = new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD");
            return fileModel;
        }
        [TestCase(null, null, null, null, null, null)]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", null, null, null, null)]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"\",\"FilePath\":\"\",\"FileExtension\":\"\",\"FileSize\":\"\"}", null)]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"\",\"FilePath\":\"https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx\",\"FileExtension\":\".xlsx\",\"FileSize\":\"7676\"}", "Goal docs,G-53")]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies.\",\"FilePath\":\"https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx\",\"FileExtension\":\".xlsx\",\"FileSize\":\"7676\"}", "Goal docs,G-53")]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"Activity-Log.xlsx\",\"FilePath\":\"\",\"FileExtension\":\".xlsx\",\"FileSize\":\"7676\"}", "Goal docs,G-53")]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"Activity-Log.xlsx\",\"FilePath\":\"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien. Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestib\",\"FileExtension\":\".xlsx\",\"FileSize\":\"7676\"}", "Goal docs,G-53")]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"Activity-Log.xlsx\",\"FilePath\":\"https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx\",\"FileExtension\":\"\",\"FileSize\":\"7676\"}", "Goal docs,G-53")]
        [TestCase("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "d3c3f943-e134-47d4-afca-5dc0b5eb1c6b", "1b35f2d3-1972-491f-8dc8-0a2a1f429934", "d64b3144-41f7-4fd2-9bb9-3083aaf00c5f",
            "{\"FileName\":\"Activity-Log.xlsx\",\"FilePath\":\"https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx\",\"FileExtension\":\"Lorem ipsum dolor sit amet, consectetuer adipiscing\",\"FileSize\":\"7676\"}", "Goal docs,G-53")]
        public void UpsertFile_UnSuccessfullyCreated_ShouldReturnNULL(string folderId, string referenceId,
            string referenceTypeId, string storeId, string filesList, string parentFolderNames)
        {
            UpsertFileInputModel fileInputModel = this.GetFileData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileUploadService fileUploadService = this.GetInstance();
            fileInputModel.FolderId = new Guid(folderId);
            fileInputModel.ReferenceTypeId = new Guid(referenceTypeId);
            fileInputModel.ReferenceId = new Guid(referenceId);
            fileInputModel.StoreId = new Guid(storeId);
            fileInputModel.FilesList = JsonConvert.DeserializeObject<List<FileModel>>(filesList);
            var folderNames = parentFolderNames.Split(',');
            foreach (var folderName in folderNames)
            {
                fileInputModel.ParentFolderNames.Add(folderName);
            }
            // Act

            var result = fileUploadService.CreateMultipleFiles(fileInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase(null, null)]
        [TestCase("92A1FF92-1158-4B64-8ABF-BD815337FBFD", null)]
        [TestCase("92A1FF92-1158-4B64-8ABF-BD815337FBFD", "Lorem ipsum dolor sit amet, consectetuer adipiscing")]
        public void UpdateFile_UnSuccessfullyCreated_ShouldReturnNull(string fileId, string fileName)
        {
            FileModel fileInputModel = this.GetUpdateFileData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act
            fileInputModel.FileId = new Guid(fileId);
            fileInputModel.FileName = fileName;

            var result = fileUploadService.UpdateFile(fileInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase(null)]
        public void ReviewFile_UnSuccessfullyCreated_ShouldReturnNull(string fileId)
        {
            FileModel fileInputModel = this.GetUpdateFileData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeFileUploadService fileUploadService = this.GetInstance();
            // Act
            fileInputModel.FileId = new Guid(fileId);

            var result = fileUploadService.ReviewFile(fileInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase(null)]
        public void ArchiveFile_UnSuccessfullyCreated_ShouldReturnnull(string fileId)
        {
            IFakeFileUploadService fileUploadService = this.GetInstance();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            Guid? deleteFileId = new Guid(fileId);

            //Act
            var result = fileUploadService.DeleteFile(deleteFileId, loggedInContext, new List<ValidationMessage>());

            //Assert
            Assert.AreEqual(null, result);
        }
        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this._fixture.Create<LoggedInContext>();
            return loggedInContext;
        }

        private IFakeFileUploadService GetInstance()
        {
            return new FakeFileUploadService(new FakeUploadFileRepository());
        }
    }
}
