using System;

namespace BTrak.Common
{
    public class NotificationTypeConstants
    {
        public static Guid NewAssetAssigned = new Guid("86A845A5-8E52-4EBD-A4FA-90F7D8F5BAE5");
        public static Guid NewUserStoryAssigned = new Guid("32184689-FD1A-4F3B-BFF5-57A3FEBC9481");
        public static Guid AdhocNewUserStoryAssigned = new Guid("D436963A-4063-421E-8C90-1ECE778E3DFF");
        public static Guid GoalStatusUpdated = new Guid("C9BD6C25-C69B-4B86-8F5C-970C38A57744");
        public static Guid RoleUpdated = new Guid("7662113B-94D9-4665-86A9-935E3FDB2C65");
        public static Guid UserStoryStatusChange = new Guid("6B80BB8A-1881-4D97-AD18-23F3E9F4D81F");
        public static Guid UserStoryArchive = new Guid("F6586541-471C-4657-B929-832B88E56B76");
        public static Guid ParkUserStory = new Guid("8A61EF7D-A738-46BE-BA74-71CFD6D03223");
        public static Guid ArchiveProject = new Guid("ACB64E01-CEA3-4704-8CC4-F4F82C387D6F");
        public static Guid NewProject = new Guid("E9C64357-492E-47D7-A98E-350FBD613F12");
        public static Guid GoalReplan = new Guid("F8B3FD7D-1A4B-4023-84E8-88CEA28DC16D");
        public static Guid GoalApprovedFromReplan = new Guid("80513474-1DD1-4A6B-8336-AFE11A7370FE");
        public static Guid UserStoryTypeAsBug = new Guid("1DEE906B-C56B-410E-A3C1-C89ABA484753");
        public static Guid ProjectMemberRoleAdded = new Guid("6747F62C-1B90-4805-98B3-93DA6D8F6195");
        public static Guid ProjectMemberRoleUpdated = new Guid("E9F51C6F-6982-408F-940F-20990869E8EB");
        public static Guid ProjectFeature = new Guid("0C85E7B0-CCC1-4C4F-AF39-1942A40B4C7D");
        public static Guid NewStatusConfigurationAssigned = new Guid("D182D572-D314-43F7-B953-B132DFC048D2");
        public static Guid NewStatusReportSumitted = new Guid("0B67AF9D-2C08-481A-99D0-B4ECB334386D");
        public static Guid NewMultiChartsScheduling = new Guid("935F6891-9029-482D-B6D8-A0A62673E47A");
        public static Guid UserStoryUpdateNotificationTypeId = new Guid("E004EF10-1787-4AB3-8B31-DC48D58F68D0");
        public static Guid AdhocUserStoryUpdateNotificationTypeId = new Guid("BB04BB53-E26A-4588-B694-FB893098C61B");
        public static Guid AnnouncementReceivedNotificationTypeId = new Guid("36F28A72-D3B3-42E2-A495-FC49453BAFFB");
        public static Guid ReminderNotificationTypeId = new Guid("A2811F64-DCE6-4FE5-BDE3-D5AD6EA4EB61");
        public static Guid PerformanceNotificationTypeId = new Guid("622FFD3A-8A2B-4C84-94EE-8E4CBA986650");
        public static Guid SprintStarted = new Guid("29C2059A-B2B6-49EC-A61B-C0D9BF4A9898");
        public static Guid PushNotificationForUserStoryComment = new Guid("5AEFF52D-4F36-414C-A3D5-BA7AA4774B18");
        public static Guid SprintReplan = new Guid("2B1D4317-EAA9-4CB2-A5A8-8F187BE6ADBC");
        public static Guid RosterApproved = new Guid("4FA1DEBD-E5D1-46B8-A244-92B480B78BD5");
        public static Guid SubmitTimeSheet = new Guid("3D5341EE-AFF0-49F6-A596-9D0D540CF0AC");
        public static Guid TimesheetApproved = new Guid("9D1D0ED1-C96B-4FE6-8BEF-A7B849C193A0");
        public static Guid TimesheetRejected = new Guid("EAD6B78E-B017-4766-A2C4-E6756CA7E865");
        public static Guid UserProfileImageUpdate = new Guid("504348FB-DCCC-402F-BD01-9EAF7A5E0B8B");
        public static Guid GenericNotificationActivity = new Guid("750B94A6-1D1F-43F5-9843-1BB1A7ADD8AB");
        public static Guid LeaveNotification = new Guid("2ABD0FD7-5A6E-BEB5-B02A-B9D4E69DC493");
        public static Guid ApproveLeaveNotification = new Guid("A4E3ABFC-F234-474E-A3F0-4D4F692A6DC3");
        public static Guid RejectLeaveNotification = new Guid("5E9AD394-D415-40F5-8E5B-D79F3E033FB8");
        public static Guid ResignationNotification = new Guid("987A697A-6161-4BC9-8D21-14BE1189E594");
        public static Guid ResignationApprovalNotification = new Guid("8A3CAFF7-651C-45D3-BD3B-E682A5081A52");
        public static Guid ResignationRejectionNotification = new Guid("6651A770-42B0-4015-AE8B-74D162F6A7B2");
        public static Guid AutoTimeSheetSubmissionNotification = new Guid("FE3C8D88-304D-4B1D-B6A6-370E2CD25913");
        public static Guid ProbationAssignNotification = new Guid("F75527DB-AF69-4905-89B5-388789989FBE");
        public static Guid ReviewAssignToEmployeeNotification = new Guid("A1256DB2-B40A-4189-A9A4-63B5D153B0B9");
        public static Guid ReviewSubmittedByEmployeeNotification = new Guid("5E0F808D-9908-4EC2-B805-456D94419631");
        public static Guid ReviewInvitationNotification = new Guid("733DE5A1-4E8D-44D8-9F49-5079B8DF37AA");
        public static Guid PerformanceReviewSubmittedByEmployeeNotification = new Guid("A75D64FC-83BE-4BE1-9B24-BF4850F6C3AE");
        public static Guid PerformanceReviewInvitationNotificationModel = new Guid("56487941-867E-456B-9090-D076742150D6");
        public static Guid PerformanceReviewAssignToEmployeeNotification = new Guid("47DC740D-3AF7-4219-A0B1-805876CC13FC");
        public static Guid PurchaseExecutionAssignToEmployeeNotification = new Guid("67100C98-7133-4213-AD98-30F6BEEC983C");


    }
}