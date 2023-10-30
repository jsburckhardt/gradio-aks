import os

from azure.identity import DefaultAzureCredential
from langchain.chains import ConversationChain
from langchain.chat_models import AzureChatOpenAI
from langchain.memory import ConversationBufferMemory

# Get the Azure Credential
# credential = ChainedTokenCredential(ManagedIdentityCredential(), AzureCliCredential())
credential = DefaultAzureCredential()

# Set the API type to `azure_ad`
# Set the API_KEY to the token from the Azure credential
os.environ["OPENAI_API_TYPE"] = "azure_ad"
os.environ["OPENAI_API_BASE"] = "https://llm-experiment.openai.azure.com/"
os.environ["OPENAI_API_VERSION"] = "2023-05-15"
os.environ["OPENAI_API_KEY"] = credential.get_token(
    "https://cognitiveservices.azure.com/.default"
).token

llm = AzureChatOpenAI(
    deployment_name="gpt-35-turbo",
    temperature=0,
)

# print(llm.predict("Hello, how are you?"))
memory = ConversationBufferMemory()
conversation = ConversationChain(llm=llm, memory=memory)
