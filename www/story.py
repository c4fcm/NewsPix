from date import Date 

class Story:

	def __init__(self, headline, storyURL, imageURL, fromDate, toDate, _id, loadCount, clickCount):
		self.headline = headline
		self.storyURL = storyURL
		self.imageURL = imageURL
		self.fromDate = fromDate
		self.toDate = toDate
		self._id = _id
		self.date_handler = Date()
		if fromDate is not None:
			self.formatedFromDate = self.date_handler.format_date(fromDate)
		if toDate is not None:
			self.formatedToDate = self.date_handler.format_date(toDate)
		self.loadCount = loadCount
		self.clickCount = clickCount
		if loadCount == 0 or loadCount == None or clickCount == 0 or clickCount == None:
			self.clickthrough = 0
		else:
			self.clickthrough = loadCount / clickCount

	def get_story_object(self):
		story = {}
		story['headline'] = self.headline
		story['url'] = self.storyURL
		story['image'] = self.imageURL
		story['date'] = self.fromDate
		story['to_date'] = self.toDate
		story['load_count'] = self.loadCount
		story['click_count'] = self.clickCount
		story['clickthrough'] = self.clickthrough
		if not self._id:
			return story
		else:
			story['_id'] = self._id
			return story