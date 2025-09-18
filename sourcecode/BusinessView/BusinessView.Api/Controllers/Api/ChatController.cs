using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using BusinessView.Api.Models.ChatModel;
using BusinessView.Api.PushNotificationHelpers;
using BusinessView.Common;
using BusinessView.DAL;

namespace BusinessView.Api.Controllers.Api
{
    public class ChatController : ApiController
    {
        [HttpGet]
        [ActionName("UpdateUserLoginStatus")]
        [Authorize]
        public async Task<bool> UpdateUserLoginStatus(int userId)
        {
            var result = false;

            try
            {
                using (var entities = new BViewEntities())
                {
                    var loggedInUserDetails = await entities.Users.Where(x => x.Id == userId).FirstOrDefaultAsync();

                    if (loggedInUserDetails != null)
                    {
                        loggedInUserDetails.IsActiveOnMobile = true;

                        entities.Users.AddOrUpdate(loggedInUserDetails);

                        entities.SaveChanges();

                        result = true;
                    }

                    return result;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return result;
        }

        [HttpGet]
        [ActionName("LogoutUser")]
        [Authorize]
        public async Task<bool> LogoutUser(int userId)
        {
            var result = false;

            try
            {
                using (var entities = new BViewEntities())
                {
                    var loggedInUserDetails = await entities.Users.Where(x => x.Id == userId).FirstOrDefaultAsync();

                    if (loggedInUserDetails != null)
                    {
                        loggedInUserDetails.IsActiveOnMobile = false;

                        entities.Users.AddOrUpdate(loggedInUserDetails);

                        entities.SaveChanges();

                        result = true;
                    }

                    return result;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return result;
        }

        [HttpGet]
        [ActionName("GetAllUsers")]
        [Authorize]
        public async Task<List<UserDto>> GetAllUsers(int userId)
        {
            var usersListDto = new List<UserDto>();

            try
            {
                using (var entities = new BViewEntities())
                {
                    var usersList = await entities.Users.Where(x => x.Id != userId && x.IsActive == true).ToListAsync();

                    if (usersList.Count > 0)
                    {
                        foreach (var user in usersList)
                        {
                            var userDto = new UserDto
                            {
                                Id = user.Id,
                                Name = user.Name,
                                UserName = user.UserName,
                                RoleId = Convert.ToInt32(user.RoleId),
                                IsActive = Convert.ToBoolean(user.IsActive),
                                SurName = user.SurName,
                                IsActiveOnMobile = Convert.ToBoolean(user.IsActiveOnMobile),
                                ProfileImage = user.ProfileImage
                            };

                            usersListDto.Add(userDto);
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return usersListDto;
        }

        [HttpGet]
        [ActionName("GetMessagesListBetweenUsers")]
        [Authorize]
        public async Task<List<ConversationDto>> GetMessagesListBetweenUsers(int senderId, int recieverId)
        {
            var conversationListDto = new List<ConversationDto>();

            try
            {
                using (var entities = new BViewEntities())
                {
                    var messagesList = await entities.Messages.Where(x => (x.SenderUserId == senderId && x.ReceiverUserId == recieverId) || (x.SenderUserId == recieverId && x.ReceiverUserId == senderId) && x.IsDeleted != true).ToListAsync();

                    if (messagesList.Count > 0)
                    {
                        foreach (var message in messagesList)
                        {
                            var senderDetails = await entities.Users
                                .Where(x => x.Id == message.SenderUserId).FirstOrDefaultAsync();

                            var recieverDetails = await entities.Users
                                .Where(x => x.Id == message.ReceiverUserId).FirstOrDefaultAsync();

                            if (senderDetails != null && recieverDetails != null)
                            {
                                var conversationDto = new ConversationDto
                                {
                                    SenderId = Convert.ToInt32(message.SenderUserId),
                                    SenderName = senderDetails.Name,
                                    RecieverId = Convert.ToInt32(message.ReceiverUserId),
                                    RecieverName = recieverDetails.Name,
                                    MessageId = message.Id,
                                    MessageTime = Convert.ToDateTime(message.MessageDateTime),
                                    TextMessage = message.TextMessage

                                };

                                conversationListDto.Add(conversationDto);
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return conversationListDto;
        }

        [HttpPost]
        [ActionName("SendMessageToMember")]
        [Authorize]
        public async Task<bool> SendMessageToMember(MessageDto messageDto)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    if (messageDto != null)
                    {
                        var messageDetails = new Message
                        {
                            SenderUserId = messageDto.SenderId,
                            ReceiverUserId = messageDto.RecieverId,
                            MessageDateTime = DateTime.Now,
                            TextMessage = messageDto.Message
                        };

                        entities.Messages.Add(messageDetails);

                        entities.SaveChanges();


                        Task.Factory.StartNew(async () =>
                        {
                            try
                            {
                                await PushNotificationController.SendNotificationToReciever(messageDto.RecieverId, messageDto.SenderId);
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(exception);
                            }
                        });

                        return true;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }

            return false;
        }

        [HttpGet]
        [ActionName("GetAllChannels")]
        [Authorize]
        public async Task<List<ChannelDto>> GetAllChannels(int userId)
        {
            var channelsDto = new List<ChannelDto>();

            try
            {
                using (var entities = new BViewEntities())
                {
                    var channelsList = await entities.ChannelMembers.Where(x => x.MemberUserId == userId).ToListAsync();

                    if (channelsList.Count > 0)
                    {
                        foreach (var channel in channelsList)
                        {
                            var channelDetails = await entities.Channels.Where(x => x.Id == channel.ChannelId).FirstOrDefaultAsync();

                            if (channelDetails != null)
                            {
                                var channelDto = new ChannelDto
                                {
                                    ChannelId = channelDetails.Id,
                                    ChannelName = channelDetails.ChannelName
                                };

                                channelsDto.Add(channelDto);
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }

            return channelsDto;
        }

        [HttpGet]
        [ActionName("GetChannelConversation")]
        [Authorize]
        public async Task<List<ChannelConversationDto>> GetChannelConversation(int channelId)
        {
            var channelConversationList = new List<ChannelConversationDto>();

            try
            {
                using (var entities = new BViewEntities())
                {
                    var messagesList = await entities.ChannelMessages.Where(x => x.ChannelId == channelId && x.IsDeleted != true).ToListAsync();

                    if (messagesList.Count > 0)
                    {
                        foreach (var message in messagesList)
                        {
                            var senderDetails = await entities.Users.Where(x => x.Id == message.SenderUserId)
                                .FirstOrDefaultAsync();

                            if (senderDetails != null)
                            {
                                var conversationDto = new ChannelConversationDto
                                {
                                    MessageId = message.Id,
                                    SenderId = Convert.ToInt32(message.SenderUserId),
                                    SenderName = senderDetails.Name,
                                    TextMessage = message.TextMessage,
                                    MessageTime = Convert.ToDateTime(message.MessageDateTime)
                                };

                                channelConversationList.Add(conversationDto);
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
            return channelConversationList;
        }

        [HttpPost]
        [ActionName("SendMessageToChannel")]
        [Authorize]
        public async Task<bool> SendMessageToChannel(ChannelMessageDto channelMessageDto)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    if (channelMessageDto != null && channelMessageDto.ChannelId != 0)
                    {
                        var messageDetails = new ChannelMessage
                        {
                            SenderUserId = channelMessageDto.SenderId,
                            MessageDateTime = DateTime.Now,
                            TextMessage = channelMessageDto.TextMessage,
                            ChannelId = channelMessageDto.ChannelId,
                        };

                        entities.ChannelMessages.Add(messageDetails);

                        entities.SaveChanges();

                        Task.Factory.StartNew(async () =>
                        {
                            try
                            {
                                await PushNotificationController.SendChannelMessageNotification(channelMessageDto.SenderId, channelMessageDto.ChannelId);
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(exception);
                            }
                        });

                        return true;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }

            return false;
        }

        [HttpPost]
        [ActionName("CreateNewChannel")]
        [Authorize]
        public async Task<bool> CreateNewChannel(NewChannelDto channelDetailsDto)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var channel = new Channel
                    {
                        ChannelName = channelDetailsDto.ChannelName
                    };

                    entities.Channels.Add(channel);
                    entities.SaveChanges();

                    var channelDetails = await entities.Channels.Where(x => x.ChannelName == channelDetailsDto.ChannelName).FirstOrDefaultAsync();

                    if (channelDetails != null && channelDetailsDto.MembersList != null && channelDetailsDto.MembersList.Count > 0)
                    {
                        foreach (var member in channelDetailsDto.MembersList)
                        {
                            var channelMemberEntity = new ChannelMember
                            {
                                ChannelId = channelDetails.Id,
                                MemberUserId = member,
                                ActiveFrom = DateTime.Now
                            };

                            entities.ChannelMembers.Add(channelMemberEntity);
                            entities.SaveChanges();
                        }

                        return true;
                    }

                    return false;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        [HttpGet]
        [ActionName("CheckForAdmin")]
        [Authorize]
        public async Task<bool> CheckForAdmin(int userId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var userDetails = await entities.Users.Where(x => x.Id == userId).FirstOrDefaultAsync();

                    if (userDetails != null)
                    {
                        if (Convert.ToBoolean(userDetails.IsAdmin))
                        {
                            return true;
                        }

                        return false;
                    }

                    return false;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        [HttpGet]
        [ActionName("GetDetailsToAddNewEmployee")]
        [Authorize]
        public async Task<DefaultEmployeeDetailsDto> GetDetailsToAddNewEmployee()
        {
            try
            {
                var details = new DefaultEmployeeDetailsDto();

                using (var entities = new BViewEntities())
                {
                    var userRoles = await entities.Roles.ToListAsync();

                    var jobLocations = await entities.Branches.ToListAsync();

                    var timeZones = await entities.TimeZones.ToListAsync();

                    if (userRoles.Count > 0 && jobLocations.Count > 0 && timeZones.Count > 0)
                    {
                        details.Roles = new List<string>();

                        details.Locations = new List<string>();

                        details.TimeZones = new List<string>();

                        foreach (var role in userRoles)
                        {
                            details.Roles.Add(role.RoleName);
                        }

                        foreach (var location in jobLocations)
                        {
                            details.Locations.Add(location.BranchName);
                        }

                        foreach (var timeZone in timeZones)
                        {
                            details.TimeZones.Add(timeZone.DisplayName);
                        }
                    }
                }

                return details;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }

        [HttpGet]
        [ActionName("CheckForUserExistance")]
        [Authorize]
        public async Task<bool> CheckForUserExistance(string emailId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var userDetails = await entities.Users.Where(x => x.UserName == emailId).FirstOrDefaultAsync();

                    if (userDetails == null)
                    {
                        return true;
                    }

                    return false;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        [HttpPost]
        [ActionName("CreateNewEmployee")]
        [Authorize]
        public async Task<bool> CreateNewEmployee(NewEmployeeDto newEmployeeDto)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    if (newEmployeeDto != null)
                    {
                        var userRoleDetails = await entities.Roles.Where(x => x.RoleName == newEmployeeDto.EmployeeRole).FirstOrDefaultAsync();

                        var userJobLocationDetails = await entities.Branches.Where(x => x.BranchName == newEmployeeDto.EmployeeJobLocation).FirstOrDefaultAsync();

                        var timeZoneDetails = await entities.TimeZones.Where(x => x.DisplayName == newEmployeeDto.EmployeeTimeZone).FirstOrDefaultAsync();

                        if (userRoleDetails != null && userJobLocationDetails != null && timeZoneDetails != null)
                        {
                            var newUserDetails = new User
                            {
                                Name = newEmployeeDto.Name,
                                UserName = newEmployeeDto.EmailId,
                                Password = AppUtilities.GetSaltedPassword("Test123!"),
                                RoleId = userRoleDetails.Id,
                                IsActive = true,
                                SurName = newEmployeeDto.SurName,
                                BranchId = userJobLocationDetails.Id,
                                TimeZoneId = timeZoneDetails.Id,
                                MobileNo = newEmployeeDto.MobileNumber,
                                EmployeeId = newEmployeeDto.EmployeeId,
                                IsPasswordForceReset = false,
                                IsAdmin = newEmployeeDto.IsAdmin
                            };

                            entities.Users.Add(newUserDetails);

                            entities.SaveChanges();

                            return true;
                        }

                        return false;
                    }

                    return false;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        [HttpGet]
        [ActionName("GetChannelUsers")]
        [Authorize]
        public async Task<List<ChannelUsersDto>> GetChannelUsers(int channelId)
        {
            try
            {
                var channelUsersList = new List<ChannelUsersDto>();

                using (var entities = new BViewEntities())
                {
                    if (channelId != 0)
                    {
                        var channelMembersList = await entities.ChannelMembers.Where(x => x.ChannelId == channelId && x.ActiveTo == null).ToListAsync();

                        if (channelMembersList.Count > 0)
                        {
                            foreach (var channelMember in channelMembersList)
                            {
                                var userDetails = await entities.Users.Where(x => x.Id == channelMember.MemberUserId && x.IsActive == true).FirstOrDefaultAsync();

                                if (userDetails != null)
                                {
                                    var channelUser = new ChannelUsersDto
                                    {
                                        Id = userDetails.Id,
                                        Name = userDetails.Name,
                                        UserName = userDetails.UserName,
                                        RoleId = Convert.ToInt32(userDetails.RoleId),
                                        IsActive = Convert.ToBoolean(userDetails.IsActive),
                                        SurName = userDetails.SurName,
                                        IsActiveOnMobile = Convert.ToBoolean(userDetails.IsActiveOnMobile),
                                        ProfilePicture = userDetails.ProfileImage
                                    };

                                    channelUsersList.Add(channelUser);
                                }
                            }
                        }
                    }
                }

                return channelUsersList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }

        [HttpGet]
        [ActionName("GetRemainingUsersOfChannel")]
        [Authorize]
        public async Task<List<ChannelUsersDto>> GetRemainingUsersOfChannel(int channelId)
        {
            try
            {
                var usersList = new List<ChannelUsersDto>();

                using (var entities = new BViewEntities())
                {
                    if (channelId != 0)
                    {
                        var employeesList = await entities.Users.Where(x => x.IsActive == true).ToListAsync();

                        if (employeesList.Count > 0)
                        {
                            foreach (var employee in employeesList)
                            {
                                var memberExistance = await entities.ChannelMembers.Where(x => x.MemberUserId == employee.Id && x.ChannelId == channelId).FirstOrDefaultAsync();

                                if (memberExistance == null)
                                {
                                    var channelUser = new ChannelUsersDto
                                    {
                                        Id = employee.Id,
                                        Name = employee.Name,
                                        UserName = employee.UserName,
                                        RoleId = Convert.ToInt32(employee.RoleId),
                                        IsActive = Convert.ToBoolean(employee.IsActive),
                                        SurName = employee.SurName,
                                        IsActiveOnMobile = Convert.ToBoolean(employee.IsActiveOnMobile),
                                        ProfilePicture = employee.ProfileImage
                                    };

                                    usersList.Add(channelUser);
                                }
                                else if (memberExistance.ActiveTo != null)
                                {
                                    var inactiveChannelUser = new ChannelUsersDto
                                    {
                                        Id = employee.Id,
                                        Name = employee.Name,
                                        UserName = employee.UserName,
                                        RoleId = Convert.ToInt32(employee.RoleId),
                                        IsActive = Convert.ToBoolean(employee.IsActive),
                                        SurName = employee.SurName,
                                        IsActiveOnMobile = Convert.ToBoolean(employee.IsActiveOnMobile),
                                        ProfilePicture = employee.ProfileImage
                                    };

                                    usersList.Add(inactiveChannelUser);
                                }
                            }
                        }
                    }
                }

                return usersList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }

        [HttpPost]
        [ActionName("AddNewEmployeesToChannel")]
        [Authorize]
        public async Task<bool> AddNewEmployeesToChannel(AddEmployeesToChannelDto employeesDto)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    if (employeesDto != null)
                    {
                        if (employeesDto.MembersList.Count > 0)
                        {
                            foreach (var member in employeesDto.MembersList)
                            {
                                var channelMemberExistance = await entities.ChannelMembers.Where(x => x.ChannelId == employeesDto.ChannelId && x.MemberUserId == member).FirstOrDefaultAsync();

                                if (channelMemberExistance == null)
                                {
                                    var channelMember = new ChannelMember
                                    {
                                        ChannelId = employeesDto.ChannelId,
                                        MemberUserId = member,
                                        ActiveFrom = DateTime.Now
                                    };

                                    entities.ChannelMembers.Add(channelMember);
                                    entities.SaveChanges();
                                }
                                else if (channelMemberExistance.ActiveTo != null)
                                {
                                    channelMemberExistance.ActiveTo = null;
                                    entities.ChannelMembers.AddOrUpdate(channelMemberExistance);
                                    entities.SaveChanges();
                                }
                            }

                            return true;
                        }
                    }
                }

                return false;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }


        [HttpPost]
        [ActionName("DeleteAnEmployeeFromChannel")]
        [Authorize]
        public async Task<bool> DeleteAnEmployeeFromChannel(ChannelMemberDto channelMemberDto)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    if (channelMemberDto.MemberUserId != 0 && channelMemberDto.ChannelId != 0)
                    {
                        var channelMemberExistance = await entities.ChannelMembers.Where(x => x.ChannelId == channelMemberDto.ChannelId && x.MemberUserId == channelMemberDto.MemberUserId).FirstOrDefaultAsync();

                        if (channelMemberExistance != null)
                        {
                            channelMemberExistance.ActiveTo = DateTime.Now;
                            entities.ChannelMembers.AddOrUpdate(channelMemberExistance);
                            entities.SaveChanges();
                        }
                        return true;
                    }
                }

                return false;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        [HttpGet]
        [ActionName("ArcheiveEmployee")]
        [Authorize]
        public async Task<bool> ArcheiveEmployee(int userId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var userDetails = await entities.Users.Where(x => x.Id == userId).FirstOrDefaultAsync();

                    if (userDetails != null)
                    {
                        userDetails.IsActive = false;
                        entities.Users.AddOrUpdate(userDetails);
                        entities.SaveChanges();
                        return true;
                    }

                    return false;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }
    }
}