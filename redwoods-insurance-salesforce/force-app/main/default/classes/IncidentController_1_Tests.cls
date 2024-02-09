
@isTest
public class IncidentController_1_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;

        // Insert audio content version and link to the case
        ContentVersion audioContentVersion = new ContentVersion(
            Title = 'TestAudio',
            PathOnClient = 'TestAudio.m4a',
            VersionData = Blob.valueOf('Test audio data'),
            IsMajorVersion = true
        );
        insert audioContentVersion;
        // Get the ContentDocumentId from the ContentVersion
        audioContentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :audioContentVersion.Id LIMIT 1];
        ContentDocumentLink audioLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = audioContentVersion.ContentDocumentId
        );
        insert audioLink;
        
        // Insert image content version and link to the case
        ContentVersion imageContentVersion = new ContentVersion(
            Title = 'TestImage',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test image data'),
            IsMajorVersion = true
        );
        insert imageContentVersion;
        // Get the ContentDocumentId from the ContentVersion
        imageContentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :imageContentVersion.Id LIMIT 1];
        ContentDocumentLink imageLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = imageContentVersion.ContentDocumentId
        );
        insert imageLink;
    }

    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testFindRelatedAudioFiles() {
        bypassTriggers();
        Test.startTest();
        // Retrieve the test case from setup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        List<ContentVersion> audioFiles = IncidentController.findRelatedFiles(testCase.Id, 'AUDIO');
        Test.stopTest();

        System.assertNotEquals(null, audioFiles, 'The result should not be null.');
        System.assertEquals(1, audioFiles.size(), 'There should be one audio file related to the case.');
    }

    @isTest
    static void testFindRelatedImageFiles() {
        bypassTriggers();
        Test.startTest();
        // Retrieve the test case from setup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        List<ContentVersion> imageFiles = IncidentController.findRelatedFiles(testCase.Id, 'IMAGE');
        Test.stopTest();

        System.assertNotEquals(null, imageFiles, 'The result should not be null.');
        System.assertEquals(1, imageFiles.size(), 'There should be one image file related to the case.');
    }

    @isTest
    static void testFindNoRelatedAudioFiles() {
        bypassTriggers();
        Test.startTest();
        // Assuming there are no audio files related to this case
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        List<ContentVersion> audioFiles = IncidentController.findRelatedFiles(testCase.Id, 'AUDIO');
        Test.stopTest();

        System.assertEquals(null, audioFiles, 'There should be no audio files related to the case.');
    }

    @isTest
    static void testFindNoRelatedImageFiles() {
        bypassTriggers();
        Test.startTest();
        // Assuming there are no image files related to this case
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        List<ContentVersion> imageFiles = IncidentController.findRelatedFiles(testCase.Id, 'IMAGE');
        Test.stopTest();

        System.assertEquals(null, imageFiles, 'There should be no image files related to the case.');
    }

    @isTest
    static void testFindRelatedFilesWithNullCaseId() {
        bypassTriggers();
        Test.startTest();
        List<ContentVersion> files = IncidentController.findRelatedFiles(null, 'AUDIO');
        Test.stopTest();

        System.assertEquals(null, files, 'The result should be null when caseId is null.');
    }

    @isTest
    static void testFindRelatedFilesWithInvalidFileType() {
        bypassTriggers();
        Test.startTest();
        // Retrieve the test case from setup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        List<ContentVersion> files = IncidentController.findRelatedFiles(testCase.Id, 'DOCUMENT');
        Test.stopTest();

        System.assertEquals(null, files, 'The result should be null for an invalid file type.');
    }
}
