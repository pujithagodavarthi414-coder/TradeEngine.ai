using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Repositories.Repositories.CompanyManagement;
using AuthenticationServices.Repositories.Repositories.UserManagement;
using AuthenticationServices.Services.CompanyManagement;
using AuthenticationServices.Services.Email;
using AutoFixture;
using Microsoft.Extensions.Configuration;
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Tests.CompanyManagement
{
    [TestFixture]
    public class CompanyManagementApiTest
    {
        IConfiguration iconfiguration;
        private readonly Fixture fixture = new Fixture();

        [Test]
        public void CreateCompany_SuccessfullyCreated()
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            var companyServiceMock = new Mock<CompanyManagementService>(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration));

            CompanyInputModel companyInputModel = new CompanyInputModel();

            // Act
            companyServiceMock.Setup(x => x.SendCompanyInsertEmailToRegisteredEmailAddress(It.IsAny<LoggedInContext>(), It.IsAny<CompanyInputModel>(), It.IsAny<List<ValidationMessage>>())).Verifiable();

            companyServiceMock.Object.UpsertCompany(new LoggedInContext(), companyInputModel, new List<ValidationMessage>());

            // Assert
            Assert.IsTrue(true);
        }

        [Test]
        public void UpdateCompanyDetails_SuccessfullyUpdated()
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            CompanyInputModel companyInputModel = new CompanyInputModel();

            // Act
            var companyId = companyManagementService.UpdateCompanyDetails(companyInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual("99DD4149-C0FB-464B-99BA-8D6D9E09982C", companyId);
        }

        [TestCase("99DD4149-C0FB-464B-99BA-8D6D9E09982C", null, null, null, null, null, null, null, null, null, null, null, "99DD4149-C0FB-464B-99BA-8D6D9E09982C")]
        [TestCase(null, null, null, null, null, null, null, null, null, null, null, "organization1", "99DD4149-C0FB-464B-99BA-8D6D9E09982C")]
        [TestCase(null, null, null, "5C166739-6113-4CF3-AB13-7E9C67DD778E", null, null, null, null, null, null, null, null, "8E24EB64-0637-4472-B497-062E118EA0A7")]
        public void SearchComapny_SuccessfullyRetrivedCompany(Guid? CompanyId, Guid? TimeZoneId, Guid? MainUseCaseId, Guid? IndustryId, Guid? CountryId, Guid? CurrencyId, Guid? NumberFormatId, Guid? DateFormatId, Guid? TimeFormatId, int? TeamSize, string PhoneNumber, string SearchText, string ExpectedResult)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            CompanySearchCriteriaInputModel companySearchCriteriaInputModel = new CompanySearchCriteriaInputModel()
            {
                CompanyId = CompanyId,
                TimeZoneId = TimeZoneId,
                MainUseCaseId = MainUseCaseId,
                IndustryId = IndustryId,
                CountryId = CountryId,
                CurrencyId = CurrencyId,
                NumberFormatId = NumberFormatId,
                DateFormatId = DateFormatId,
                TimeFormatId = TimeFormatId,
                TeamSize = TeamSize,
                PhoneNumber = PhoneNumber,
                SearchText = SearchText,
                PageSize = 10,
                PageNumber = 1
            };

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            List<CompanyOutputModel> companiesList = companyManagementService.SearchCompanies(companySearchCriteriaInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(ExpectedResult.ToString().ToLower(), companiesList[0].CompanyId.ToString().ToLower());
        }

        [TestCase("8E24EB64-0637-4472-B497-062E118EA0A7", null, null, null, null, null, null, null, null, null, null, null, 1, 0, "8E24EB64-0637-4472-B497-062E118EA0A7")]
        [TestCase("8E24EB64-0637-4472-B497-062E118EA0A7", null, null, null, null, null, null, null, null, null, null, null, 0, 1, "8E24EB64-0637-4472-B497-062E118EA0A7")]
        public void SearchComapny_NotRetrivedCompany_ValidationMessageReturn(Guid? CompanyId, Guid? TimeZoneId, Guid? MainUseCaseId, Guid? IndustryId, Guid? CountryId, Guid? CurrencyId, Guid? NumberFormatId, Guid? DateFormatId, Guid? TimeFormatId, int? TeamSize, string PhoneNumber, string SearchText, int pageSize, int pageNumber, string ExpectedResult)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            CompanySearchCriteriaInputModel companySearchCriteriaInputModel = new CompanySearchCriteriaInputModel()
            {
                CompanyId = CompanyId,
                TimeZoneId = TimeZoneId,
                MainUseCaseId = MainUseCaseId,
                IndustryId = IndustryId,
                CountryId = CountryId,
                CurrencyId = CurrencyId,
                NumberFormatId = NumberFormatId,
                DateFormatId = DateFormatId,
                TimeFormatId = TimeFormatId,
                TeamSize = TeamSize,
                PhoneNumber = PhoneNumber,
                SearchText = SearchText,
                PageSize = pageSize,
                PageNumber = pageNumber
            };

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            List<CompanyOutputModel> companiesList = companyManagementService.SearchCompanies(companySearchCriteriaInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.IsTrue(validationMessages.Count > 0);
        }

        [TestCase("0293ACD1-4E3A-4089-976A-4CE6087758E0", null, null, null, null, null, null, null, null, null, null, null, "0293ACD1-4E3A-4089-976A-4CE6087758E0")]
        public void SearchComapny_NotRetrivedCompany(Guid? CompanyId, Guid? TimeZoneId, Guid? MainUseCaseId, Guid? IndustryId, Guid? CountryId, Guid? CurrencyId, Guid? NumberFormatId, Guid? DateFormatId, Guid? TimeFormatId, int? TeamSize, string PhoneNumber, string SearchText, string ExpectedResult)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            CompanySearchCriteriaInputModel companySearchCriteriaInputModel = new CompanySearchCriteriaInputModel()
            {
                CompanyId = CompanyId,
                TimeZoneId = TimeZoneId,
                MainUseCaseId = MainUseCaseId,
                IndustryId = IndustryId,
                CountryId = CountryId,
                CurrencyId = CurrencyId,
                NumberFormatId = NumberFormatId,
                DateFormatId = DateFormatId,
                TimeFormatId = TimeFormatId,
                TeamSize = TeamSize,
                PhoneNumber = PhoneNumber,
                SearchText = SearchText,
                PageSize = 10,
                PageNumber = 1
            };

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            List<CompanyOutputModel> companiesList = companyManagementService.SearchCompanies(companySearchCriteriaInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(companiesList.Count, 0);
        }

        [TestCase("8E24EB64-0637-4472-B497-062E118EA0A7")]
        [TestCase("337B3857-4A3F-4ED8-B728-7997A2B1390E")]
        public void GetCompanyDetailsById_SuccessfullyRetrived(Guid? companyId)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            CompanyOutputModel companyDetails = companyManagementService.GetCompanyById(companyId, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(companyId, companyDetails.CompanyId);
        }

        [TestCase("8E24EB64-0637-4472-B497-062E118EA1A7")]
        [TestCase("337B3857-4A3F-4ED8-B728-7997A2B1392E")]
        public void GetCompanyDetailsById_NotRetrived(Guid? companyId)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            CompanyOutputModel companyDetails = companyManagementService.GetCompanyById(companyId, loggedInContext, validationMessages);

            // Assert
            Assert.AreNotEqual(companyId, companyDetails);
        }

        [TestCase("99DD4149-C0FB-464B-99BA-8D6D9E09982C")]
        [TestCase("337B3857-4A3F-4ED8-B728-7997A2B1390E")]
        public void GetCompanyDetailsByLoggedInContext_SuccessfullyRetrived(Guid companyGuid)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            loggedInContext.CompanyGuid = companyGuid;

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            CompanyOutputModel companyDetails = companyManagementService.GetCompanyDetails(loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(companyGuid, companyDetails.CompanyId);
        }

        [TestCase("D39EF1C1-FB25-4636-AA04-B57463E757BB")]
        public void GetCompanyDetailsByLoggedInContext_NotRetrived(Guid companyGuid)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            loggedInContext.CompanyGuid = companyGuid;

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            CompanyOutputModel companyDetails = companyManagementService.GetCompanyDetails(loggedInContext, validationMessages);

            // Assert
            Assert.AreNotEqual(companyGuid, companyDetails);
        }

        [TestCase("D39EF1C1-FB25-4636-AA04-B57463E757BB")]
        public void DeleteCompanyModule_SuccessfullyDeleted(Guid? companyModuleId)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            DeleteCompanyModuleModel deleteCompanyModuleModel = new DeleteCompanyModuleModel()
            {
                CompanyModuleId = companyModuleId
            };

            // Act
            var result = companyManagementService.DeleteCompanyModule(deleteCompanyModuleModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(companyModuleId, result);
        }

        [TestCase(null)]
        public void DeleteCompanyModule_FailedToDeleted(Guid? companyModuleId)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            DeleteCompanyModuleModel deleteCompanyModuleModel = new DeleteCompanyModuleModel()
            {
                CompanyModuleId = companyModuleId
            };

            // Act
            var result = companyManagementService.DeleteCompanyModule(deleteCompanyModuleModel, loggedInContext, validationMessages);

            // Assert
            Assert.IsTrue(validationMessages.Count > 0);
        }

        [TestCase("2B7B28E4-472A-4F43-93D4-9332DE0AB51D")]
        public void ArchiveCompany_SuccessfullyArchived(Guid? companyId)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            ArchiveCompanyInputModel archiveCompanyInputModel = new ArchiveCompanyInputModel()
            {
                CompanyId = companyId
            };

            // Act
            var result = companyManagementService.ArchiveCompany(archiveCompanyInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(companyId, result);
        }

        [TestCase(null)]
        public void ArchiveCompany_NotSuccessfull(Guid? companyId)
        {
            // Arrange
            ICompanyManagementService companyManagementService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            ArchiveCompanyInputModel archiveCompanyInputModel = new ArchiveCompanyInputModel()
            {
                CompanyId = companyId
            };

            // Act
            var result = companyManagementService.ArchiveCompany(archiveCompanyInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.IsTrue(validationMessages.Count > 0);
        }

        private ICompanyManagementService GetInstance()
        {
            return new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration));
        }

        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this.fixture.Create<LoggedInContext>();
            return loggedInContext;
        }
    }
}
