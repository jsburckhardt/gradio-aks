import os

from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
from langchain.chains import ConversationChain
from langchain.chat_models import AzureChatOpenAI
from langchain.memory import ConversationBufferMemory

# Set the Azure Credential
credential = DefaultAzureCredential()

# Load OPENAI_API_TYPE, OPENAI_API_BASE, OPENAI_API_VERSION
load_dotenv()
# Set OPENAI_API_KEY
os.environ["OPENAI_API_KEY"] = credential.get_token(
    "https://cognitiveservices.azure.com/.default"
).token

# print TEMPERATURE from .env
llm = AzureChatOpenAI(
    deployment_name=os.getenv("DEPLOYMENT_NAME"),
    temperature=os.getenv("TEMPERATURE"),
)

# print(llm.predict("Hello, how are you?"))
memory = ConversationBufferMemory()
conversation = ConversationChain(llm=llm, memory=memory)
