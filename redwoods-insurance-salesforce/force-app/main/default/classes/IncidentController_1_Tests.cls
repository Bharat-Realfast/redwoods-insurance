
@isTest
public class IncidentController_1_Tests {
    @testSetup
    static void setup() {
        // Create test data
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;

        // Create audio content
        ContentVersion audioContent = new ContentVersion(
            Title = 'TestAudio',
            PathOnClient = 'TestAudio.m4a',
            VersionData = Blob.valueOf('Test data'),
            IsMajorVersion = true
        );
        insert audioContent;
        // Link the audio content to the case
        ContentDocumentLink audioLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = audioContent.ContentDocumentId
        );
        insert audioLink;

        // Create image content
        ContentVersion imageContent = new ContentVersion(
            Title = 'TestImage',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test data'),
            IsMajorVersion = true
        );
        insert imageContent;
        // Link the image content to the case
        ContentDocumentLink imageLink = new ContentDocumentLink(
            LinkedEntityId = testCase.Id,
            ContentDocumentId = imageContent.ContentDocumentId
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
        // Create test data without any audio files associated
        
        // Retrieve the test case from setup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        // Simulate the query for audio files
        List<ContentVersion> audioFiles = IncidentController.findRelatedFiles(testCase.Id, 'AUDIO');
        
        System.assertEquals(null, audioFiles, 'There should be no audio files related to the case.');
    }

    @isTest
    static void testFindNoRelatedImageFiles() {
        bypassTriggers();
        // Create test data without any image files associated
        
        // Retrieve the test case from setup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        // Simulate the query for image files
        List<ContentVersion> imageFiles = IncidentController.findRelatedFiles(testCase.Id, 'IMAGE');
        
        System.assertEquals(null, imageFiles, 'There should be no image files related to the case.');
    }

    @isTest
    static void testFindRelatedFilesWithNullCaseId() {
        bypassTriggers();
        List<ContentVersion> files = IncidentController.findRelatedFiles(null, 'AUDIO');
        // Null case ID should be handled by method and return null
        System.assertEquals(null, files, 'The method should return null for null caseId.');
    }

    @isTest
    static void testFindRelatedFilesWithInvalidFileType() {
        bypassTriggers();
        // Retrieve the test case from setup
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        List<ContentVersion> files = IncidentController.findRelatedFiles(testCase.Id, 'VIDEO');
        // Invalid file type should be handled by method and return null
        System.assertEquals(null, files, 'The result should be null for an invalid file type.');
    }
}
