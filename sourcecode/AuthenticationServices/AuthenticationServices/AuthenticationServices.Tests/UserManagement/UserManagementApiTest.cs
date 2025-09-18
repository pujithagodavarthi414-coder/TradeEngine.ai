using NUnit.Framework;
using System;
using System.Collections.Generic;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Employee;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Repositories.CompanyManagement;
using AuthenticationServices.Repositories.Repositories.UserManagement;
using AuthenticationServices.Services.CompanyManagement;
using AuthenticationServices.Services.Email;
using AutoFixture;
using AuthenticationServices.Services.UserManagement;
using FakeItEasy;
using Microsoft.Extensions.Configuration;
using Moq;
using AuthenticationServices.Repositories.Repositories.MasterDataManagement;

namespace AuthenticationServices.Tests.UserManagement
{
    [TestFixture]
    public class UserManagementApiTest
    {
        IConfiguration iconfiguration;
        private readonly Fixture fixture = new Fixture();

        [Test]
        public void AddUser_SuccessfullyCreated_ShouldReturnId()
        {
            // Arrange
            UserInputModel userInput = this.GetUser();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();
            userInput.UserId = null;

            var userServiceMock = new Mock<UserManagementService>(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration)),
                new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration), iconfiguration, new FakeMasterDataManagementRepository());

            // Act
            userServiceMock.Setup(x => x.EnqueueBackgroundJob(It.IsAny<UserInputModel>(), It.IsAny<UserRegistrationDetailsModel>(), It.IsAny<LoggedInContext>(), It.IsAny<List<ValidationMessage>>()));
            var result = userServiceMock.Object.UpsertUser(userInput, loggedInContext, new List<ValidationMessage>());
            
            // Assert
            Assert.AreEqual(new Guid("5D893EB5-CDE3-45E0-9290-2382220CB709"), new Guid(result.ToString()));
        }

        [TestCase(null, null, null, null)]
        [TestCase("", "", "", "")]
        [TestCase("test", "test", "test@test", null)]
        [TestCase("test", "test", null, "test")]
        [TestCase("test", null, "test@test", "test")]
        [TestCase(null, "test", "test@test", "test")]
        public void AddUser_UnSuccessfullyCreated_ShouldReturnNULL(string FirstName, string LastName, string Email, string RoleId)
        {
            // Arrange
            UserInputModel userInput = this.GetUser();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();
            userInput.UserId = null;
            userInput.FirstName = FirstName;
            userInput.SurName = LastName;
            userInput.Email = Email;
            userInput.RoleId = RoleId;

            var userServiceMock = new Mock<UserManagementService>(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration)),
                new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration), iconfiguration);

            // Act
            userServiceMock.Setup(x => x.EnqueueBackgroundJob(It.IsAny<UserInputModel>(), It.IsAny<UserRegistrationDetailsModel>(), It.IsAny<LoggedInContext>(), It.IsAny<List<ValidationMessage>>()));
            var result = userServiceMock.Object.UpsertUser(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreNotEqual(new Guid("5D893EB5-CDE3-45E0-9290-2382220CB709"), result);
        }

        [Test]
        public void UpdateUser_UpdatedSuccessfully_ShouldReturnId()
        {
            // Arrange
            UserInputModel userInput = this.GetUser();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            var userServiceMock = new Mock<UserManagementService>(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration)),
                new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration), iconfiguration);

            // Act
            userServiceMock.Setup(x => x.EnqueueBackgroundJob(It.IsAny<UserInputModel>(), It.IsAny<UserRegistrationDetailsModel>(), It.IsAny<LoggedInContext>(), It.IsAny<List<ValidationMessage>>()));
            var result = userServiceMock.Object.UpsertUser(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("5D893EB5-CDE3-45E0-9290-2382220CB709"), new Guid(result.ToString()));
        }

        [TestCase(null, null, null, null, null)]
        [TestCase("", "", "", "", "")]
        [TestCase("test", "test", "test@test", "test", null)]
        [TestCase("test", "test", "test@test", null, "test")]
        [TestCase("test", "test", null, "test", "test")]
        [TestCase("test", null, "test@test", "test", "test")]
        [TestCase(null, "test", "test@test", "test", "test")]
        public void UpdateUser_UpdatedUnSuccessfully_ShouldReturnNULL(string FirstName, string LastName, string Email, string Password, string RoleId)
        {
            // Arrange
            UserInputModel userInput = this.GetUser();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();
            userInput.FirstName = FirstName;
            userInput.SurName = LastName;
            userInput.Email = Email;
            userInput.Password = Password;
            userInput.RoleId = RoleId;

            var userServiceMock = new Mock<UserManagementService>(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration)),
                new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration), iconfiguration);

            // Act
            userServiceMock.Setup(x => x.EnqueueBackgroundJob(It.IsAny<UserInputModel>(), It.IsAny<UserRegistrationDetailsModel>(), It.IsAny<LoggedInContext>(), It.IsAny<List<ValidationMessage>>()));
            var result = userServiceMock.Object.UpsertUser(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreNotEqual(new Guid("5D893EB5-CDE3-45E0-9290-2382220CB709"), result);
        }

        [TestCase(true)]
        [TestCase(false)]
        public void UpdateUserToActiveOrInActive_UpdatedSuccessfully_ShouldReturnId(bool IsActive)
        {
            // Arrange
            UserInputModel userInput = this.GetUser();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();
            userInput.IsActive = IsActive;
            
            var userServiceMock = new Mock<UserManagementService>(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration)),
                new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration), iconfiguration);

            // Act
            userServiceMock.Setup(x => x.EnqueueBackgroundJob(It.IsAny<UserInputModel>(), It.IsAny<UserRegistrationDetailsModel>(), It.IsAny<LoggedInContext>(), It.IsAny<List<ValidationMessage>>()));
            var result = userServiceMock.Object.UpsertUser(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(new Guid("5D893EB5-CDE3-45E0-9290-2382220CB709"), new Guid(result.ToString()));
        }
        [Test]
        public void GetAllUsers_SuccessfullyRetrived_ShouldReturnAllListOfUsers()
        {
            // Arrange
            UserSearchCriteriaInputModel userInput = new UserSearchCriteriaInputModel();//this.GetUserInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            // Act
            var userList = GetUsersList(loggedInContext);
            var result = userService.GetAllUsers(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(result.Count, 4);
            Assert.AreEqual(result[0].Email, "test@test.com");
        }

        [Test]
        public void GetAllUsers_SuccessfullyRetrived_ShouldReturnListOfUsers_ByEmailSearchText()
        {
            // Arrange
            UserSearchCriteriaInputModel userInput = new UserSearchCriteriaInputModel();//this.GetUserInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            userInput.SearchText = "test2@test.com";
            // Act
            var result = userService.GetAllUsers(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(result[0].Email, "test2@test.com");
        }

        [Test]
        public void GetAllUsers_SuccessfullyRetrived_ShouldReturnListOfUsers_ByRoleSearchText()
        {
            // Arrange
            UserSearchCriteriaInputModel userInput = new UserSearchCriteriaInputModel();//this.GetUserInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            userInput.SearchText = "Role3";
            // Act
            var result = userService.GetAllUsers(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(result[0].RoleName, "Role3");
        }

        [Test]
        public void GetAllUsers_NoUsersRetrived_BySearchTextWithNoDetails()
        {
            // Arrange
            UserSearchCriteriaInputModel userInput = new UserSearchCriteriaInputModel();//this.GetUserInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            userInput.SearchText = "Role4";
            // Act
            var result = userService.GetAllUsers(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(result.Count, 0);
        }

        [TestCase("yes", 3)]
        [TestCase("no", 1)]
        public void GetAllUsers_SuccessfullyRetrived_ShouldReturnListOfUsers_ByActiveSearchText(string searchText , int count)
        {
            // Arrange
            UserSearchCriteriaInputModel userInput = new UserSearchCriteriaInputModel();//this.GetUserInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            userInput.SearchText = searchText;
            // Act
            var result = userService.GetAllUsers(userInput, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(result.Count, count);
        }

        [Test]
        public void GetUserById_SuccessfullyRetrived_ShouldReturnUserDetails()
        {
            // Arrange
            UserSearchCriteriaInputModel userInput = this.GetUserInputModel();
            LoggedInContext loggedInContext = this.GetLoggedInContext();

            IUserManagementService userService = this.GetInstance();

            // Act
            var result = userService.GetUserById(new Guid("DAE20421-988E-408C-A788-319D2968A628"), null, loggedInContext, new List<ValidationMessage>());

            // Assert
            Assert.AreEqual(result.Email, "test1@test.com");
        }

        private UserInputModel GetUser()
        {
            var user = this.fixture.Create<UserInputModel>();
            user.FirstName = "test";
            user.SurName = "test";
            user.Email = "test@test.com";
            return user;
        }

        private UserSearchCriteriaInputModel GetUserInputModel()
        {
            var result = this.fixture.Create<UserSearchCriteriaInputModel>();
            return result;
        }

        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this.fixture.Create <LoggedInContext>();
            return loggedInContext;
        }

        private IUserManagementService GetInstance()
        {
            return new UserManagementService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), new CompanyManagementService(new FakeCompanyManagementRepository(), new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration)), 
                new EmailService(new FakeUserManagementRepository(), new FakeCompanyManagementRepository(), iconfiguration), iconfiguration, new FakeMasterDataManagementRepository());
        }

        private void TriggerFakeMethod(UserInputModel userInput, LoggedInContext loggedInContext)
        {
            var fakeService = A.Fake<IUserManagementService>();
            A.CallTo(() => fakeService.EnqueueBackgroundJob(userInput, new UserRegistrationDetailsModel(),
                loggedInContext, new List<ValidationMessage>()));
        }

        private void EnqueueBackgroundJob(UserInputModel userInput, LoggedInContext loggedInContext)
        {
            Console.WriteLine("BackgroundJobEnqueued");
        }

        private List<UserOutputModel> GetUsersList(LoggedInContext loggedInContext)
        {
            List<UserOutputModel> userOutput = new List<UserOutputModel>();
            var result = new UserOutputModel();
            result.Id = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C");
            result.UserId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C");
            result.FirstName = "test";
            result.SurName = "test";
            result.FullName = "test test";
            result.Email = "test@test.com";
            result.RoleName = "Role";
            result.MobileNo = "";
            result.IsActive = true;
            result.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(result);

            result = new UserOutputModel();
            result.Id = new Guid("DAE20421-988E-408C-A788-319D2968A628");
            result.UserId = new Guid("DAE20421-988E-408C-A788-319D2968A628");
            result.FirstName = "test1";
            result.SurName = "test1";
            result.FullName = "test1 test1";
            result.Email = "test1@test.com";
            result.RoleName = "Role1";
            result.MobileNo = "";
            result.IsActive = false;
            result.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(result);

            result = new UserOutputModel();
            result.Id = new Guid("B68C7B00-0C4F-4F18-98B2-3F845D1FBABA");
            result.UserId = new Guid("B68C7B00-0C4F-4F18-98B2-3F845D1FBABA");
            result.FirstName = "test2";
            result.SurName = "test2";
            result.FullName = "test2 test2";
            result.Email = "test2@test.com";
            result.RoleName = "Role2";
            result.MobileNo = "";
            result.IsActive = true;
            result.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(result);

            result = new UserOutputModel();
            result.Id = new Guid("B46B7D0B-3AA3-4B4B-897B-C088EFCBABD2");
            result.UserId = new Guid("B46B7D0B-3AA3-4B4B-897B-C088EFCBABD2");
            result.FirstName = "test3";
            result.SurName = "test3";
            result.FullName = "test3 test3";
            result.Email = "test3@test.com";
            result.RoleName = "Role3";
            result.MobileNo = "";
            result.IsActive = true;
            result.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(result);

            return userOutput;
        }
    }
}
