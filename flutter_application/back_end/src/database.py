import sqlalchemy as _sql
import sqlalchemy.ext.declarative as _declarative
import sqlalchemy.orm as _orm
from sqlalchemy_repr import RepresentableBase

SQLALCHEMY_DATABASE_URL = "sqlite:///./database.db"
metadata = _sql.MetaData()
engine = _sql.create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

SessionLocal = _orm.sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = _declarative.declarative_base(cls=RepresentableBase)
metadata.create_all(engine)