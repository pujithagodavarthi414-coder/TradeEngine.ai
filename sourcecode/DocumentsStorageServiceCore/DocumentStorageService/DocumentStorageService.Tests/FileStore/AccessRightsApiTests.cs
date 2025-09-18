using AutoFixture;
using DocumentStorageService.Models;
using Microsoft.Extensions.Configuration;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Repositories.Fake;
using DocumentStorageService.Services.Fake;
using DocumentStorageService.Repositories.AccessRights;
using Newtonsoft.Json;
using DocumentStorageService.Services.Helpers;

namespace DocumentStorageService.Tests.FileStore
{
    [TestFixture]
    public  class AccessRightsApiTests
    {
        IConfiguration iconfiguration;
        private readonly Fixture _fixture = new Fixture();

        [Test]
        public void CreateAccessPermission_OnSuccess_Should_Return_NewId()
        {
            DocumentRightAccessModel accessModel = this.GetDocumentsAccessData();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeAccessService fakeAccessService = this.GetInstance();
            // Act

            var result = fakeAccessService.InsertAccessRightsPrmissionToDocuments(accessModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("38b9969f-5e31-46f9-b244-c86e02f51d3c"), new Guid(result.ToString()));

        }

        [Test]
        public void SearchDocumentsAccessPermissions_SuccessfullyReturn()
        {
            // Arrange
            var validationMessages = new List<ValidationMessage>();
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            AccessRightsSearchInputModel accessRightsSearchCriteriaInput = new AccessRightsSearchInputModel();
            accessRightsSearchCriteriaInput.IsArchived = false;
          
            IFakeAccessService fakeAccessService = this.GetInstance();
            // Act

            var result = fakeAccessService.SearchAccessRightPermissionsForDocuments(accessRightsSearchCriteriaInput, loggedInContext, new List<ValidationMessage>());
            var expectedResult = SearchAccessData();
            // Assert
            AreEqualByObject(expectedResult, result);
        }

        [TestCase(null,false,false,true)]
        [TestCase("6333CE8B-166C-4029-9D1A-9EE923B4DBCA",false,false,true)]
        public void InsertDocumentUnSuccessFulShouldReturnId(string documentId,bool? isCreateAccess, bool? isViewAccess, bool? isEditAccess)
        {
            DocumentRightAccessModel accessModel = new DocumentRightAccessModel();
            accessModel.DocumentId = Guid.Parse(documentId);
            accessModel.IsCreateAccess = isCreateAccess;
            accessModel.IsViewAccess = isViewAccess;
            accessModel.IsEditAccess = isEditAccess;
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IFakeAccessService fakeAccessService = this.GetInstance();
            // Act

            var result = fakeAccessService.InsertAccessRightsPrmissionToDocuments(accessModel, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(null, new Guid(result.ToString()));

        }

        [TestCase(null,  "5D893EB5-CDE3-45E0-9290-2382220CB704")]
        public void SearchAccessDocument_UnSuccessfullyReturn(bool? isArchived, string id)
        {
            // Arrange
            AccessRightsSearchInputModel accessSearchCriteriaInput = new AccessRightsSearchInputModel();
            accessSearchCriteriaInput.IsArchived = false;
            accessSearchCriteriaInput.DocumentId = Guid.Parse(id);
            LoggedInContext loggedInContext = this.GetLoggedInContext();
            var validationMessages = new List<ValidationMessage>();
            IFakeAccessService fakeAccessService = this.GetInstance();
            // Act

            var result = fakeAccessService.SearchAccessRightPermissionsForDocuments(accessSearchCriteriaInput, loggedInContext, validationMessages);
            // Assert
            Assert.AreEqual(false, validationMessages.Count == 0);
        }

        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this._fixture.Create<LoggedInContext>();
            return loggedInContext;
        }

        private IFakeAccessService GetInstance()
        {
            return new FakeAccessService(new FakeAccessRightsRepository());
        }

        public List<DocumentRightAccessModel> SearchAccessData()
        {
           
            return new List<DocumentRightAccessModel>
            {
                new DocumentRightAccessModel
                {
                    DocumentId = Guid.Parse("38b9969f-5e31-46f9-b244-c86e02f51d3c"),
                    UserIds = null,
                    RoleIds = new List<Guid?>(),
                    IsCreateAccess = false,
                    IsViewAccess = false,
                    IsEditAccess = true,
                    IsArchived = false
                }
            };
        }

        private DocumentRightAccessModel GetDocumentsAccessData()
        {
            var documentAccessModel = new DocumentRightAccessModel();
            documentAccessModel.DocumentId = Guid.Parse("38b9969f-5e31-46f9-b244-c86e02f51d3c");
            var userIds = new List<Guid?>();
            userIds.Add(Guid.Parse("fdc73d7d-7f60-4bfd-aeba-405bb50999fb"));
            userIds.Add(Guid.Parse("0a54decb-db73-416b-8453-d4c2b647dfcd"));
            userIds.Add(Guid.Parse("b0e945ac-6d2b-4bbd-8416-b09a5e435358"));
            documentAccessModel.UserIds = userIds;
            documentAccessModel.IsCreateAccess = true;
            return documentAccessModel;
        }

        public static void AreEqualByObject(List<DocumentRightAccessModel> expected, List<DocumentRightAccessModel> actual)
        {
            var expectedJson = JsonConvert.SerializeObject(expected);
            var actualJson = JsonConvert.SerializeObject(actual);
            Assert.AreEqual(expectedJson, actualJson);
        }

    }

}
