using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using AuthenticationServices.Repositories.Repositories.RoleManagement;
using AuthenticationServices.Services.Role;
using AutoFixture;
using Microsoft.Extensions.Configuration;
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Tests.RoleManagement
{
    [TestFixture]
    public class RoleManagementApiTest
    {
        IConfiguration iconfiguration;
        private readonly Fixture fixture = new Fixture();

        [Test]
        public void CreateRole_SuccessfullyCreated_ShouldReturnId()
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesInputModel roleModel = new RolesInputModel()
            {
                RoleName = "R1"
            };
            // Act
            Guid? roleId = roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual("93A92096-ADEA-4443-B521-BE60ED12670D".ToLower(), roleId.ToString().ToLower());
        }

        [Test]
        public void CreateRole_NotSuccessfullyCreated_ShouldReturnNULL()
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesInputModel roleModel = new RolesInputModel()
            {
                RoleName = null
            };
            // Act
            var roleId = roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(null, roleId);
        }

        [Test]
        public void UpdateRole_Successfull_ShouldReturnId()
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesInputModel roleModel = new RolesInputModel()
            {
                RoleName = "R1",
                RoleId = new Guid("93A92096-ADEA-4443-B521-BE60ED12670D")
            };
            // Act
            var roleId = roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual("93A92096-ADEA-4443-B521-BE60ED12670D".ToLower(), roleId.ToString().ToLower());
        }

        [Test]
        public void UpdateRole_NotSuccessfull_ShouldReturnNULL()
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesInputModel roleModel = new RolesInputModel()
            {
                RoleName = null,
                RoleId = new Guid("93A92096-ADEA-4443-B521-BE60ED12670D")
            };
            // Act
            var roleId = roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(null, roleId);
        }

        [TestCase("93A92096-ADEA-4443-B521-BE60ED12670D")]
        public void DeleteRole_SuccessfullyDeleted_ShouldReturnId(Guid roleIdInput)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesInputModel roleModel = new RolesInputModel()
            {
                RoleId = new Guid(roleIdInput.ToString()),
                RoleName = "R1"
            };
            // Act
            var roleId = roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(roleIdInput, roleId);
        }

        [TestCase(null)]
        public void DeleteRole_NotSuccessfullyDeleted_ShouldReturnNULL(Guid? roleIdInput)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesInputModel roleModel = new RolesInputModel()
            {
                RoleId = roleIdInput
            };
            // Act
            var roleId = roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

            // Assert
            Assert.IsTrue(validationMessages.Count > 0);
        }

        [TestCase(null, null, null, 10, 1, null, "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        [TestCase(null, null, "R3", 10, 1, false, "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        [TestCase(null, null, null, 10, 1, true, "30C0DC15-EC04-4C10-8F03-5F6EC46B5A82")]
        public void GetAllRoles_SuccessfullyRetrived_ShouldReturnAllListOfRoles(Guid? RoleId, string RoleName, string SearchText, int PageSize, int PageNumber, bool? IsArchived, Guid ExpectedRoleId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesSearchCriteriaInputModel roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel()
            {
                RoleId = RoleId,
                RoleName = RoleName,
                SearchText = SearchText,
                PageSize = PageSize,
                PageNumber = PageNumber,
                IsArchived = IsArchived
            };
            // Act
            var rolesList = roleService.GetAllRoles(roleSearchCriteriaInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(ExpectedRoleId, rolesList[0].RoleId);
        }

        [TestCase(null, null, null, 0, 1, null, null)]
        [TestCase(null, null, null, 10, 0, null, null)]
        public void GetAllRoles_NotRetrived_ShouldReturnNULL(Guid? RoleId, string RoleName, string SearchText, int PageSize, int PageNumber, bool? IsArchived, Guid? ExpectedRoleId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            RolesSearchCriteriaInputModel roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel()
            {
                RoleId = RoleId,
                RoleName = RoleName,
                SearchText = SearchText,
                PageSize = PageSize,
                PageNumber = PageNumber,
                IsArchived = IsArchived
            };
            // Act
            var rolesList = roleService.GetAllRoles(roleSearchCriteriaInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(ExpectedRoleId, rolesList);
        }

        [TestCase("EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        //[TestCase("12A9B6EC-F1B6-4695-9FFF-4B55789DEDF6")]
        public void GetRoleById_SuccessfullyRetrived(Guid? roleId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            var role = roleService.GetRoleById(roleId, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(roleId , role.RoleId);
        }

        [TestCase("30C0DC15-EC04-4C10-8F03-5F6EC46B5A82")]
        public void GetRoleById_FailedToRetrive(Guid? roleId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            var role = roleService.GetRoleById(roleId, loggedInContext, validationMessages);

            // Assert
            Assert.AreNotEqual(roleId, role.RoleId);
        }

        [TestCase("27CF289D-49E0-4C4F-9F77-F079570FDD3F", "27CF289D-49E0-4C4F-9F77-F079570FDD3F")]
        [TestCase("F7560B48-A220-400D-8149-42CEF300007A", "F7560B48-A220-400D-8149-42CEF300007A")]
        [TestCase(null, "27CF289D-49E0-4C4F-9F77-F079570FDD3F")]
        public void GetRolesByFeatureId_SuccessfullyRetrived(Guid? featureId, Guid? expectedFeaturedId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            var role = roleService.GetRolesByFeatureId(featureId, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(expectedFeaturedId, role[0].FeatureId);
        }

        [TestCase("6749F864-E274-40D4-B6C4-14FB7C94AC64", "6749F864-E274-40D4-B6C4-14FB7C94AC64")]
        public void GetRolesByFeatureId_NotSuccessfullyRetrived(Guid? featureId, Guid? expectedFeaturedId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            var role = roleService.GetRolesByFeatureId(featureId, loggedInContext, validationMessages);

            // Assert
            Assert.IsTrue(role.Count == 0);
        }

        [TestCase(null, "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        public void GetAllRolesDropDown_SuccessfullyRetrived(string searchText, Guid? expectedRoleId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            var role = roleService.GetAllRolesDropDown(searchText, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(expectedRoleId, role[0].RoleId);
        }

        [TestCase("Test", "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        public void GetAllRolesDropDown_NotSuccessfullyRetrived(string searchText, Guid? expectedRoleId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            // Act
            var role = roleService.GetAllRolesDropDown(searchText, loggedInContext, validationMessages);

            // Assert
            Assert.IsTrue(role.Count == 0);
        }

        [TestCase("0C78BD21-1031-4C10-AC81-113EB74242A5", null, "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        [TestCase(null, "A95896A0-1A72-46F5-97B1-3549117569F6", "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        public void UpdateRoleFeature_SuccessfullyUpdated(Guid? roleId, Guid? featureId, Guid? expectedRoleFeatureId)
        {
            // Arrange
            IRoleService roleService = this.GetInstance();

            LoggedInContext loggedInContext = this.GetLoggedInContext();

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            UpdateFeatureInputModel updateFeatureInputModel = new UpdateFeatureInputModel()
            {
                RoleId = roleId,
                FeatureId = featureId
            };

            // Act
            var roleFeatureId = roleService.UpdateRoleFeature(updateFeatureInputModel, loggedInContext, validationMessages);

            // Assert
            Assert.AreEqual(expectedRoleFeatureId, roleFeatureId);
        }

        //[TestCase("0C78BD21-1031-4C10-AC81-113EB74242A5", null,"EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        //[TestCase(null, "A95896A0-1A72-46F5-97B1-3549117569F6", "EA4F9C44-AEEA-47C9-9976-475CF4065738")]
        //public void UpdateRoleFeature_NotSuccessfullyUpdated(Guid? roleId, Guid? featureId, Guid? expectedRoleFeatureId)
        //{
        //    // Arrange
        //    IRoleService roleService = this.GetInstance();

        //    LoggedInContext loggedInContext = this.GetLoggedInContext();

        //    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

        //    UpdateFeatureInputModel updateFeatureInputModel = new UpdateFeatureInputModel()
        //    {
        //        RoleId = roleId,
        //        FeatureId = featureId
        //    };

        //    // Act
        //    var roleFeatureId = roleService.UpdateRoleFeature(updateFeatureInputModel, loggedInContext, validationMessages);

        //    // Assert
        //    Assert.AreEqual(expectedRoleFeatureId, roleFeatureId);
        //}
        private IRoleService GetInstance()
        {
            return new RoleService(new FakeRoleRepository());
        }

        private LoggedInContext GetLoggedInContext()
        {
            var loggedInContext = this.fixture.Create<LoggedInContext>();
            return loggedInContext;
        }
    }
}
