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
    public class StoreApiTests
    {
        IConfiguration iconfiguration;
        private readonly Fixture _fixture = new Fixture();

        [Test]
        public void CreateStore_OnSuccess_Should_Return_NewId()
        {
            StoreInputModel storeInputModel = this.GetStoreData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeStoreService storeService = this.GetInstance();
            // Act

            var result = storeService.UpsertStore(storeInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3"), new Guid(result.ToString()));

        }

        [Test]
        public void UpdateFile_OnSuccess_Should_Return_FileId()
        {
            StoreInputModel storeInputModel = this.GetUpdateStoreData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeStoreService storeService = this.GetInstance();
            // Act

            var result = storeService.UpsertStore(storeInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3"), new Guid(result.ToString()));

        }

        [Test]
        public void ArchiveStore_OnSuccess_Should_Return_True()
        {
            IFakeStoreService storeService = this.GetInstance();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            //Arrange
            Guid storeId = Guid.NewGuid();

            //Act
            var result = storeService.ArchiveStore(storeId, loggedInContext, new List<ValidationMessage>());

            //Assert
            Assert.AreEqual(true, result);
        }

        [Test]
        public void SearchStore_SuccessfullyReturn()
        {
            // Arrange
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            StoreCriteriaSearchInputModel storeSearchCriteriaInput = new StoreCriteriaSearchInputModel();
            storeSearchCriteriaInput.IsArchived = false;
            storeSearchCriteriaInput.CompanyId = loggedInContext.CompanyGuid;
            IFakeStoreService storeService = this.GetInstance();
            // Act

            var result = storeService.SearchStore(storeSearchCriteriaInput, loggedInContext,
                new List<ValidationMessage>());
            var expectedResult = SearchStoreData();
            // Assert
            AreEqualByObject(expectedResult, result);
        }

        [TestCase(null)]
        [TestCase("Lorem ipsum dolor sit amet, consectetuer adipiscing")]
        public void UpsertStore_UnSuccessfullyCreated_ShouldReturnNULL(string storeName)
        {
            StoreInputModel storeInputModel = this.GetStoreData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeStoreService fakeStoreService = this.GetInstance();

            storeInputModel.StoreName = storeName;
            // Act

            var result = fakeStoreService.UpsertStore(storeInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase(null, null)]
        [TestCase("8B80A046-B3CC-4F8F-9900-202417920CB4", null)]
        [TestCase("2EE26168-6F94-4CF1-9385-FDF084BD91F3", "Lorem ipsum dolor sit amet, consectetuer adipiscing")]
        public void UpdateStore_UnSuccessfullyCreated_ShouldReturnNull(string storeId, string storeName)
        {
            StoreInputModel storeInputModel = this.GetUpdateStoreData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeStoreService storeService = this.GetInstance();
            // Act
            storeInputModel.StoreId = new Guid(storeId);
            storeInputModel.StoreName = storeName;

            var result = storeService.UpsertStore(storeInputModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, result);
        }

        [TestCase(null)]
        [TestCase("8B80A046-B3CC-4F8F-9900-202417920CB4")]
        public void ArchiveStore_UnSuccessfullyCreated_ShouldReturnnull(string storeId)
        {
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeStoreService storeService = this.GetInstance();

            Guid? deleteStoreId = new Guid(storeId);

            //Act
            var result = storeService.ArchiveStore(deleteStoreId, loggedInContext, new List<ValidationMessage>());

            //Assert
            Assert.AreEqual(null, result);
        }

        public List<StoreOutputReturnModels> SearchStoreData()
        {
            return new List<StoreOutputReturnModels>
            {
                new StoreOutputReturnModels
                {
                    Id = new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3"),
                    StoreName = "priya doc store",
                    StoreSize = 156250,
                    CompanyId = new Guid("CF1C6756-936F-4A19-9D48-468D343F10CB"),
                    IsDefault = false,
                    IsCompany = true,
                    IsArchived = false
                }
            };
        }

        [TestCase(null, null)]
        [TestCase(false, null)]
        public void SearchStore_UnSuccessfullyReturn(bool? isArchived, string id)
        {
            // Arrange
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            IFakeStoreService fakeStoreService = this.GetInstance();
            StoreCriteriaSearchInputModel storeSearchCriteriaInput = new StoreCriteriaSearchInputModel();
            storeSearchCriteriaInput.IsArchived = isArchived;
            storeSearchCriteriaInput.Id = new Guid(id);
            storeSearchCriteriaInput.CompanyId = loggedInContext.CompanyGuid;

            var validationMessages = new List<ValidationMessage>();

            // Act
            var result = fakeStoreService.SearchStore(storeSearchCriteriaInput, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }

        public static void AreEqualByObject(List<StoreOutputReturnModels> expected,
            List<StoreOutputReturnModels> actual)
        {
            var expectedJson = JsonConvert.SerializeObject(expected);
            var actualJson = JsonConvert.SerializeObject(actual);
            Assert.AreEqual(expectedJson, actualJson);
        }

        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this._fixture.Create<LoggedInContext>();
            return loggedInContext;
        }

        private IFakeStoreService GetInstance()
        {
            return new FakeStoreService(new FakeStoreRepository());
        }

        private StoreInputModel GetStoreData()
        {
            var result = this._fixture.Create<StoreInputModel>();
            result.StoreId = new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3");
            result.StoreName = "priya doc store";
            result.IsCompany = false;
            result.IsDefault = false;
            result.CompanyId = new Guid("CF1C6756-936F-4A19-9D48-468D343F10CB");
            return result;
        }

        private StoreInputModel GetUpdateStoreData()
        {
            var storeModel = this._fixture.Create<StoreInputModel>();
            storeModel.StoreName = "priya";
            storeModel.StoreId = new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3");
            return storeModel;
        }
    }
}